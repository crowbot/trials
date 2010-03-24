require 'spec_helper'

describe Sponsor do
  before(:each) do
    @valid_attributes = {
      :agency_id => 1,
      :clinical_trial_id => 1,
      :role => "value for role"
    }
  end

  it "should create a new instance given valid attributes" do
    Sponsor.create!(@valid_attributes)
  end
end
