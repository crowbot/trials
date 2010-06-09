namespace :pubmed do 

  desc "Searches pubmed for articles related to clinical trials" 
  task :search => :environment do
    pubmed_parser = PubmedParser.new
    ClinicalTrial.find_each(:conditions => ['searched = ?', false]) do |trial|
      pubmed_ids = pubmed_parser.search_for_trial(trial.nct_id)
      trial.searched = true
      puts "Search with #{trial.nct_id}"
      pubmed_ids.each do |pubmed_id|
        article = Article.find_or_create_by_pubmed_id(pubmed_id)
        trial.trial_mentions.build(:article => article)
        puts "Found #{pubmed_id}"
      end
      trial.save!
    end 
  end
end