require 'spec_helper'

describe Topic do
  
  let(:genre) 		{ FactoryGirl.create(:genre, status: 1) }
  let(:category)	{ FactoryGirl.create(:category, status: 1, genre: genre)}
  before do
  	@topic = category.topics.build(description: "First topic")
  end

  subject { @topic }
  it { should respond_to(:description) }
  it { should respond_to(:category_id) }
  it { should respond_to(:category) }
  it { should respond_to(:created_by) }
  it { should respond_to(:status) }
  its(:category) { should eq category }
  it { should respond_to(:products) }

  it { should be_valid }

  describe "when category_id is not present" do
  	before { @topic.category_id = nil }
  	it { should_not be_valid }
  end

  describe "when associated category does not exist" do
  	before { @topic.category_id = category.id + 1 }
  	it { should_not be_valid }
  end

  describe "with a blank description" do
  	before { @topic.description = " " }
  	it { should_not be_valid }
  end

  describe "with a description that is too long" do
  	before { @topic.description = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "auto-calculation of Topic default fields" do
    before { @topic.save }
    specify { expect(@topic.created_by).to eq 1 }
    specify { expect(@topic.status).to eq 2 }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @topic.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when created_by is any whole number >= 1" do
    test_values = [ 1, 1000000]
    test_values.each do |test|
      before { @topic.created_by = test }
      it { should be_valid }
    end
  end

  describe "when the status is not in the range 1-3" do
    test_values = [ 0, -1, "three", 4, nil, 1.5]
    test_values.each do |test|
      before { @topic.status = test }
      it { should_not be_valid }
    end
  end

  describe "when status is any whole number 1-3" do
    test_values = [ 1, 2, 3]
    test_values.each do |test|
      before { @topic.status = test }
      it { should be_valid }
    end
  end

  describe "when the category/topic combination is a duplicate" do
  	before do
  		duplicate_category_topic = @topic.dup 
  		duplicate_category_topic.description = @topic.description.upcase
  		duplicate_category_topic.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "when the topic is a duplicate but the category is different" do
  	let(:different_category) {FactoryGirl.create(:category, 
  		description: "New category", genre_id: genre.id, status: 1) }
  	before do
  		@ok_duplicate_topic = different_category.topics.build(description: "First topic")
  		@ok_duplicate_topic.save
  	end

  	it { should be_valid }
  end
end
