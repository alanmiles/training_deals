require 'spec_helper'

describe Business do

  before do
  	@business = FactoryGirl.build(:business)

    #@business = Business.new(name: "Biz", country: "United Kingdom", postalcode: "M6 5GS",
  	#						region: "Lancashire", city: "Salford", street: "23 Pembroke Street",
  	#						email: "biz@example.com", description: "Just a biz")
  end

  subject { @business }

  it { should respond_to(:name) }
  it { should respond_to(:country) }
  it { should respond_to(:postalcode) }
  it { should respond_to(:region) }
  it { should respond_to(:city) }
  it { should respond_to(:street) }
  it { should respond_to(:phone) }
  it { should respond_to(:alt_phone) }
  it { should respond_to(:email) }
  it { should respond_to(:description) }
  it { should respond_to(:logo) }
  it { should respond_to(:image_1) }
  it { should respond_to(:image_2) }
  it { should respond_to(:hidden) }
  it { should be_valid }

  describe "when name is not present" do
  	before { @business.name = " " }
  	it { should_not be_valid }
  end

  describe "when name is too long" do
  	before { @business.name = "a" * 76 }
  	it { should_not be_valid }
  end

  describe "when country is not present" do
  	before { @business.country = " " }
  	it { should_not be_valid }
  end

  describe "when country is too long" do
  	before { @business.country = "a" * 51 }
  	it { should_not be_valid }
  end

  describe "when postalcode is not present" do
  	before { @business.postalcode = nil }
  	it { should be_valid }
  end

  describe "when postalcode is too long" do
  	before { @business.postalcode = "a" * 16 }
  	it { should_not be_valid }
  end

  describe "when city is not present" do
  	before { @business.city = " " }
  	it { should_not be_valid }
  end

  describe "when city is too long" do
  	before { @business.city = "a" * 26 }
  	it { should_not be_valid }
  end

  describe "when street is not present" do
  	before { @business.street = " " }
  	it { should_not be_valid }
  end

  describe "when street is too long" do
  	before { @business.street = "a" * 256 }
  	it { should_not be_valid }
  end

  describe "when email is not present" do
  	before { @business.email = " " }
  	it { should_not be_valid }
  end

  describe "when email format is invalid" do
  	it "should be invalid" do
  		addresses = %w[user@foo,com user_at_foo.org example.user@foo.
  					foo@bar_baz.com foo@bar+baz.com foo@bar..com]
  		addresses.each do |invalid_address|
  			@business.email = invalid_address
  			expect(@business).not_to be_valid
  		end
  	end
  end

  describe "when email format is valid" do
  	it "should be valid" do
  		addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
  		addresses.each do |valid_address|
  			@business.email = valid_address
  			expect(@business).to be_valid 
  		end
  	end
  end

  describe "when description is not present" do
  	before { @business.description = " " }
  	it { should_not be_valid }
  end

  describe "when description is too long" do
  	before { @business.description = "a" * 141 }
  	it { should_not be_valid }
  end

  describe "when business is a duplicate" do
  	before do
  		business_with_same_location = @business.dup 
  		business_with_same_location.city = @business.city.upcase
  		business_with_same_location.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "when business is a duplicate, though case of name is different" do
  	before do
  		business_with_same_name = @business.dup 
  		business_with_same_name.name = @business.name.upcase
  		business_with_same_name.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "when business name and country are the same but city is different" do
  	before do
  		business_with_different_city = @business.dup 
  		business_with_different_city.city = "Different city"
  		business_with_different_city.save
  	end
  	
  	it { should be_valid }
  end

  describe "when business name and city are the same but country is different" do
  	before do
  		business_with_different_country = @business.dup 
  		business_with_different_country.country = "Different country"
  		business_with_different_country.save
  	end
  	
  	it { should be_valid }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @business.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when created_by is any whole number >= 1" do
    test_values = [ 1, 1000000]
    test_values.each do |test|
      before { @business.created_by = test }
      it { should be_valid }
    end
  end
end
