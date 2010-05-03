class Article < ActiveRecord::Base
  has_many :trial_mentions
  has_many :clinical_trials, :through => :trial_mentions
end
