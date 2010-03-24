require 'spec_helper'

describe Agency do
  before(:each) do
    @valid_attributes = {
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Agency.create!(@valid_attributes)
  end
end
