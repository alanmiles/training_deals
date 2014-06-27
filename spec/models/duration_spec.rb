require 'spec_helper'

describe Duration do
  
  before { @duration = Duration.new(time_unit: "moment") }

  subject { @duration }

  it { should respond_to(:time_unit) }
  it { should be_valid }

  describe "when time_unit is not present" do
  	before { @duration.time_unit = " " }
  	it { should_not be_valid }
  end

  describe "when time_unit is too long" do
  	before { @duration.time_unit = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when time_unit is a duplicate" do
  	before do
  		duration_with_same_time_unit = @duration.dup 
  		duration_with_same_time_unit.time_unit = @duration.time_unit.upcase
  		duration_with_same_time_unit.save
  	end
  	
  	it { should_not be_valid }

  end
end
