class Agency < ActiveRecord::Base
  has_many :sponsors
  has_many :clinical_trials, :through => :sponsors
  has_many :overall_officials
  has_many :supervised_trials, :through => :overall_officials, :class_name => 'ClinicalTrial'
  acts_as_trial_aggregator
end
