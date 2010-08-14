require 'spec_helper'

describe ConditionTrial do
  before(:each) do
    @valid_attributes = {
      :condition_id => 1,
      :clinical_trial_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    ConditionTrial.create!(@valid_attributes)
  end
end
