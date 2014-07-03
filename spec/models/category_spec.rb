require 'spec_helper'

describe Category do
  
  let(:genre) { FactoryGirl.create(:genre, status: 1) }
  before do
  	@category = genre.categories.build(description: "Cat 1")
  end

  subject { @category }
  it { should respond_to(:description) }
  it { should respond_to(:genre_id) }
  it { should respond_to(:genre) }
  it { should respond_to(:created_by) }
  it { should respond_to(:status) }
  its(:genre) { should eq genre }

  it { should be_valid }

  describe "when genre_id is not present" do
  	before { @category.genre_id = nil }
  	it { should_not be_valid }
  end

  describe "when associated genre does not exist" do
  	before { @category.genre_id = genre.id + 1 }
  	it { should_not be_valid }
  end

  describe "with a blank description" do
  	before { @category.description = " " }
  	it { should_not be_valid }
  end

  describe "with a description that is too long" do
  	before { @category.description = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "auto-calculation of Genre default fields" do
    before { @category.save }
    specify { expect(@category.created_by).to eq 1 }
    specify { expect(@category.status).to eq 2 }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @category.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when created_by is any whole number >= 1" do
    test_values = [ 1, 1000000]
    test_values.each do |test|
      before { @category.created_by = test }
      it { should be_valid }
    end
  end

  describe "when the status is not in the range 1-3" do
    test_values = [ 0, -1, "three", 4, nil, 1.5]
    test_values.each do |test|
      before { @category.status = test }
      it { should_not be_valid }
    end
  end

  describe "when status is any whole number 1-3" do
    test_values = [ 1, 2, 3]
    test_values.each do |test|
      before { @category.status = test }
      it { should be_valid }
    end
  end

  describe "when the genre/category combination is a duplicate" do
  	before do
  		duplicate_genre_category = @category.dup 
  		duplicate_genre_category.description = @category.description.upcase
  		duplicate_genre_category.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "when the category is a duplicate but the genre is different" do
  	let(:different_genre) {FactoryGirl.create(:genre, description: "New genre", status: 1) }
  	before do
  		@ok_duplicate_cat = different_genre.categories.build(description: "Cat 1")
  		@ok_duplicate_cat.save
  	end

  	it { should be_valid }
  end
end
