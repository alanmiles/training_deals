require 'spec_helper'

describe TrainingMethod do
  
  before do
  	@training_method = TrainingMethod.new(description: "Platonic dialogue")
  end

  subject { @training_method }

  it { should respond_to(:description) }
  it { should respond_to(:event) }
  it { should be_valid }

  describe "when description is not present" do
  	before { @training_method.description = " " }
  	it { should_not be_valid }
  end

  describe "when description is too long" do
  	before { @training_method.description = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when description is a duplicate" do
  	before do
  		training_with_same_description = @training_method.dup 
  		training_with_same_description.description = @training_method.description.upcase
  		training_with_same_description.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "auto-calculation of position field" do
    before { @training_method.save }
    specify { expect(@training_method.position).not_to be_blank }
  end
end
