class Location < ActiveRecord::Base
  has_one :contact
  has_one :backup_contact, :class_name => 'Contact'
end
