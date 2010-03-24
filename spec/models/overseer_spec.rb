require 'spec_helper'

describe Overseer do
  before(:each) do
    @valid_attributes = {
      :clinical_trial_id => 1,
      :authority_id => 1
    }
  end

  it "should create a new instance given valid attributes" do
    Overseer.create!(@valid_attributes)
  end
end
