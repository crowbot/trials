require 'spec_helper'

describe Intervention do
  before(:each) do
    @valid_attributes = {
      :intervention_type_id => 1,
      :name => "value for name"
    }
  end

  it "should create a new instance given valid attributes" do
    Intervention.create!(@valid_attributes)
  end
end
