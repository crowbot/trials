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
end