# general application rake tasks
namespace :trials do

  desc 'Populate the database' 
  task :populate => :environment do
    # clear db
    ENV['VERSION'] = '0'
    puts 'About to migrate down to VERSION=0'
    Rake::Task['db:migrate'].invoke
    ENV['VERSION'] = nil
    Rake::Task['db:migrate'].execute
    
    # load clinicaltrials.gov
    Rake::Task['clinicaltrials:load'].invoke
    # load ISRCTN
    Rake::Task['isrctn:load'].invoke
    # search pubmed
    Rake::Task['pubmed:search'].invoke
    # update cached statistics 
    Rake::Task['trials:update_cached_statistics'].invoke
  end

  desc 'Update cached statistics'
  task :update_cached_stats => :environment do 
    Agency.find_each do |agency|
      agency.update_cached_stats
    end
    
    Condition.find_each do |condition|
      condition.update_cached_stats
    end
    
    Intervention.find_each do |intervention|
      intervention.update_cached_stats
    end
  end
end