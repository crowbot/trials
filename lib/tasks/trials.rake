namespace :trials do

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

  desc 'Add date format completion date to trial record'
  task :add_completion_dates => :environment do 
    ClinicalTrial.completed.find_each do |trial|
      trial.completion_date_as_date = Date.parse(trial.completion_date)
      puts trial.completion_date_as_date
      trial.save!
    end
  end
end