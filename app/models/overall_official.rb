class OverallOfficial < ActiveRecord::Base
  belongs_to :agency
  belongs_to :supervised_trial, :foreign_key => 'clinical_trial_id'
end
