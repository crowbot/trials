class TrialMention < ActiveRecord::Base
  belongs_to :clinical_trial
  belongs_to :article
end
