class Agency < ActiveRecord::Base
  has_many :sponsors
  has_many :clinical_trials, :through => :sponsors
end
