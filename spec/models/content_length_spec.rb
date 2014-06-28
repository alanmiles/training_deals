require 'spec_helper'

describe ContentLength do
  
  before { @length = ContentLength.new(description: "Module") }

  subject { @length }

  it { should respond_to(:description) }
  it { should be_valid }

  describe "when description is not present" do
  	before { @length.description = " " }
  	it { should_not be_valid }
  end

  describe "when description is too long" do
  	before { @length.description = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when description is a duplicate" do
  	before do
  		length_with_same_description = @length.dup 
  		length_with_same_description.description = @length.description.upcase
  		length_with_same_description.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "auto-calculation of position field" do
  	before { @length.save }
  	specify { expect(@length.position).not_to be_blank }
  end
end
