class ConditionTrial < ActiveRecord::Base
  belongs_to :condition
  belongs_to :clinical_trial
end
