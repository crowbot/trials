require 'acts_as_trial_aggregator'
ActiveRecord::Base.send(:include, Acts::TrialAggregator)