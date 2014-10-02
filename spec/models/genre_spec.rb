require 'spec_helper'

describe Genre do
  before do
  	@genre = Genre.new(description: "Sport")
  end

  subject { @genre }

  it { should respond_to(:description) }
  it { should respond_to(:position) }
  it { should respond_to(:created_by) }
  it { should respond_to(:status) }
  it { should respond_to(:categories) }
  it { should respond_to(:topics) }
  it { should respond_to(:products) }
  it { should be_valid }

  describe "when description is not present" do
  	before { @genre.description = " " }
  	it { should_not be_valid }
  end

  describe "when description is too long" do
  	before { @genre.description = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when description is a duplicate" do
  	before do
  		genre_with_same_description = @genre.dup 
  		genre_with_same_description.description = @genre.description.upcase
  		genre_with_same_description.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "auto-calculation of Genre default fields" do
    before { @genre.save }
    specify { expect(@genre.position).not_to be_blank }
    specify { expect(@genre.created_by).to eq 1 }
    specify { expect(@genre.status).to eq 2 }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @genre.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when created_by is any whole number >= 1" do
    test_values = [ 1, 1000000]
    test_values.each do |test|
      before { @genre.created_by = test }
      it { should be_valid }
    end
  end

  describe "when the status is not in the range 1-3" do
    test_values = [ 0, -1, "three", 4, nil, 1.5]
    test_values.each do |test|
      before { @genre.status = test }
      it { should_not be_valid }
    end
  end

  describe "when status is any whole number 1-3" do
    test_values = [ 1, 2, 3]
    test_values.each do |test|
      before { @genre.status = test }
      it { should be_valid }
    end
  end

  describe "Category associations" do
    before { @genre.save }
    let!(:category_1) do
      FactoryGirl.create(:category, genre: @genre, status: 1)
    end

    it "should have a new associated category" do
      expect(@genre.categories.count).to eq 1
    end

    it "should destroy associated categories" do
      categories = @genre.categories.to_a
      @genre.destroy
      expect(categories).not_to be_empty
      categories.each do |category|
        expect(Category.where(id: category.id)).to be_empty
      end
    end
  end

end
