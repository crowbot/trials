# rake tasks for isrctn data
namespace :isrctn do

    desc "Parse trials from http://www.controlled-trials.com/isrctn and save them in the db"
    task :load => :environment do 
      isrctn_parser = IsrctnParser.new
      isrctn_parser.get_all_trials()
    end

end