class Intervention < ActiveRecord::Base
  has_many :trial_interventions
  has_many :clinical_trials, :through => :trial_interventions, :uniq => true
  belongs_to :intervention_type
  acts_as_trial_aggregator
end
