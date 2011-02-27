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
    infile.each_with_index do |line,index|
      next if index == 0
      trial_data = line.strip.split("\t")
      nct_id = trial_data[0]
      pubmed_ids = trial_data[2]
      pubmed_parser.get_info_for_ids(pubmed_ids)
    end
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