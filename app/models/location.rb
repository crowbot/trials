class Location < ActiveRecord::Base
  has_one :contact
  has_one :backup_contact, :class_name => 'Contact'
  belongs_to :facility
  belongs_to :clinical_trial, :foreign_key => :trial_id
end
