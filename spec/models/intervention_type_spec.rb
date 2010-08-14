require 'spec_helper'

describe InterventionType do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    InterventionType.create!(@valid_attributes)
  end
end
