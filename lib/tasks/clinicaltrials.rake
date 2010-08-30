require 'open-uri'
# Rake tasks for clinicaltrials.gov data
namespace :clinicaltrials do

  def usage_message message
    puts ''
    puts message
    puts ''
    exit 0
  end
  
  desc "Parse trials from clinicaltrials.gov XML in DIR and save them in the db"
  task :load => :environment do 
    usage_message "usage: rake trials:load DIR=dirname" unless ENV['DIR']
    trials_parser = TrialsParser.new
    directory = ENV['DIR'] 
    Dir.chdir(directory)
    Dir.glob("*.xml").each do |filename|
      trials_parser.parse_file(File.join(directory, filename))
    end
  end
  
  desc "Look for trial results on clinicaltrials.gov" 
  task :search_for_results => :environment do 
    base_url = 'http://clinicaltrials.gov/ct2/show/results/'
    ClinicalTrial.three_years_old.find_each(:conditions => 'nct_id is not null and nct_id != ""') do |trial|
      local_path = File.join("#{RESULTS_PATH}", trial.nct_id)
      if ! File.exists?(local_path)
        url = base_url + trial.nct_id
        data = open(url).read()
        puts "Searching for #{trial.nct_id}"
        File.open(local_path, 'w') { |f| f.write(data) }
      end
      data = File.open(local_path).read
      if /No Study Results Posted on ClinicalTrials.gov for this Study/.match(data)
        puts "missing #{trial.nct_id}"
      else
        puts "found #{trial.nct_id}"
        trial.ctg_results = true
        trial.save!
      end
    end
  end
  
  
end