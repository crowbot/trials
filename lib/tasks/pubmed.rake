# rake tasks for interacting with pubmed
namespace :pubmed do 

  desc "Searches pubmed for articles related to clinical trials" 
  task :search => :environment do
    pubmed_parser = PubmedParser.new
    ClinicalTrial.find_each(:conditions => ['searched = ? or searched is null', false]) do |trial|
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
end