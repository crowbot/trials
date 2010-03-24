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

require 'spec_helper'

describe ClinicalTrial do
  before(:each) do
    @valid_attributes = {
      :url => "value for url",
      :nct_id => "value for nct_id",
      :org_study_id => "value for org_study_id",
      :secondary_ids => "value for secondary_ids",
      :brief_title => "value for brief_title",
      :official_title => "value for official_title",
      :source => "value for source",
      :has_data_monitoring_committee => false,
      :summary => "value for summary",
      :overall_status => "value for overall_status",
      :start_date => Date.today,
      :end_date => Date.today,
      :completion_date => "value for completion_date",
      :completion_date_type => "value for completion_date_type",
      :primary_completion_date => "value for primary_completion_date",
      :primary_completion_date_type => "value for primary_completion_date_type",
      :phase => "value for phase",
      :study_type => "value for study_type",
      :study_design => "value for study_design",
      :enrollment => 1,
      :enrollment_type => "value for enrollment_type",
      :condition_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ClinicalTrial.create!(@valid_attributes)
  end
end
