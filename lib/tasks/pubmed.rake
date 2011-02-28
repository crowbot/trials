# rake tasks for interacting with pubmed
namespace :pubmed do 

  desc "Searches pubmed for articles related to clinical trials" 
  task :search => :environment do
    pubmed_parser = PubmedParser.new
    ClinicalTrial.three_years_old.find_each(:conditions => ['searched = ? or searched is null', false]) do |trial|
      pubmed_ids = pubmed_parser.search_for_trial(trial)
      trial.searched = true
      pubmed_ids.each do |pubmed_id|
        article = Article.find_or_create_by_pubmed_id(pubmed_id)
        trial.trial_mentions.build(:article => article)
        puts "Found #{pubmed_id}"
      end
      trial.save!
    end 
  end
  
  desc "Get pubmed info on articles related to clinical trials"
  task :get_pubmed_info_for_trials => :environment do 
    pubmed_parser = PubmedParser.new
    infile = File.open(ENV['INFILE'])
    outfile = File.open(ENV['OUTFILE'], 'w')
    pubmed_events = ['received', 
                     'revised', 
                     'accepted', 
                     'entrez', 
                     'pubmed', 
                     'medline', 
                     'aheadofprint', 
                     'ppublish', 
                     'epublish', 
                     'pmc-release']
    headers = ['PMID', 'Journal issue publication date' 'Article Date' ]
    pubmed_events.each do |event_type|
      headers << "PubMed Date: #{event_type}"
    end
    outfile.write(headers.join("\t") + "\n")
    infile.each_with_index do |line,index|
      next if index == 0
      trial_data = line.strip.split("\t")
      nct_id = trial_data[0]
      pubmed_ids = trial_data[2]
      ids_to_dates = pubmed_parser.get_info_for_ids(pubmed_ids)
      ids_to_dates.each do |pmid,dates|
        
        columns = [pmid]
        issue_date = dates[:issue_pub_date]
        if issue_date[:medline_date]
          columns << issue_date[:medline_date]
        elsif issue_date[:year]
          vals = [issue_date[:day], issue_date[:month], issue_date[:season], issue_date[:year]].compact
          columns << "#{vals.join(" ")}"
        end
        if !dates[:article_dates] or dates[:article_dates].size == 0
          columns << ''
        elsif dates[:article_dates].size > 1 or dates[:article_dates].first[:type] != 'Electronic'
          raise "#{pmid}: Unexpected values for article dates #{dates[:article_dates].inspect}"
        else
          article_date = dates[:article_dates].first
          puts "#{article_date[:year]}-#{article_date[:month]}-#{article_date[:day]}"    
          columns << "#{article_date[:year]}-#{article_date[:month]}-#{article_date[:day]}"          
        end
        pubmed_events.each do |event_type|
          events_of_type = dates[:pubmed_dates].select{ |date_attrs| date_attrs[:type] == event_type }
          if events_of_type.size > 0
            columns << events_of_type.map{ |event| "#{event[:year]}-#{event[:month]}-#{event[:day]}" }.join(',')
          else
            columns << ''
          end
        end
        unknown_events = dates[:pubmed_dates].select{ |date_attrs| ! pubmed_events.include? date_attrs[:type] }
        if unknown_events.size > 0
          raise "#{pmid}: Unknown pubmed event types #{unknown_events.map{|event| event[:type]}.join(",")}"
        end
        outfile.write(columns.join("\t") + "\n")
      end
    end
    infile.close
    outfile.close
  end
  
  
  desc "Search pubmed for articles related to clinical trials from the original XML downloads"
  task :search_from_file => :environment do 
    pubmed_parser = PubmedParser.new
    infile = File.open(ENV['INFILE'])
    outfile = File.open(ENV['OUTFILE'], 'w')
    outfile.write(["NCT ID", "NCT alias", "Pubmed IDs"].join("\t")+"\n")
    infile.each_with_index do |line,index|
      next if index == 0
      trial_data = line.strip.split("\t")
      nct_id = trial_data[0]
      nct_aliases_string = trial_data[1]
      pubmed_ids = pubmed_parser.search_for_identifier("nct_id", nct_id)
      if nct_aliases_string
        nct_aliases = nct_aliases_string.split(",")
        nct_aliases.each do |nct_alias|
          pubmed_ids += pubmed_parser.search_for_identifier("nct_alias", nct_alias)
        end
      end
      pubmed_ids.compact!
      outfile.write([nct_id, nct_aliases_string, pubmed_ids.join(",")].join("\t") + "\n")
      outfile.flush
    end
  end
  
  desc "Write NCT IDs and aliases to a .tsv file"
  task :nct_ids_from_xml_to_file => :environment do
    trials_parser = TrialsParser.new
    directory = ENV['DIRECTORY']
    files = Dir.glob(File.join(directory, "*.xml"))
    i = 0
    outfile = File.open("#{RAILS_ROOT}/data/nct_ids_from_xml.tsv", 'w')
    outfile.write(["NCT ID", "Org Study ID", "Secondary IDs", "NCT aliases"].join("\t")+"\n")
    files.each do |file|
      attributes = trials_parser.get_trial_attributes(file,only_nct=true)
   
      i += 1
      puts i
      outfile.write([attributes[:nct_id], 
                     attributes[:org_study_id],
                     attributes[:secondary_ids], 
                     attributes[:nct_aliases]].join("\t")+"\n")
      STDOUT.flush
    end
    outfile.close()
  end
end