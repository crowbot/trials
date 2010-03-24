# == Schema Information
# Schema version: 20100318145341
#
# Table name: clinical_trials
#
#  id                            :integer(11)     not null, primary key
#  url                           :string(255)
#  nct_id                        :string(255)
#  org_study_id                  :string(255)
#  secondary_ids                 :string(255)
#  brief_title                   :string(255)
#  official_title                :string(255)
#  source                        :string(255)
#  has_data_monitoring_committee :boolean(1)
#  summary                       :text
#  overall_status                :string(255)
#  start_date                    :date
#  end_date                      :date
#  completion_date               :string(255)
#  completion_date_type          :string(255)
#  primary_completion_date       :string(255)
#  primary_completion_date_type  :string(255)
#  phase                         :string(255)
#  study_type                    :string(255)
#  study_design                  :string(255)
#  enrollment                    :integer(11)
#  enrollment_type               :string(255)
#  condition_id                  :integer(11)
#  created_at                    :datetime
#  updated_at                    :datetime
#

class ClinicalTrial < ActiveRecord::Base
  has_many :sponsors
end
