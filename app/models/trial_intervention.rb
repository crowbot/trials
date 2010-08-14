class TrialIntervention < ActiveRecord::Base
  belongs_to :clinical_trial
  belongs_to :intervention
end
