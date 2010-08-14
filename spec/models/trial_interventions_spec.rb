require 'spec_helper'

describe TrialInterventions do
  before(:each) do
    @valid_attributes = {
      :clinical_trial_id => 1,
      :intervention_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    TrialInterventions.create!(@valid_attributes)
  end
end
