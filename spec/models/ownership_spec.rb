require 'spec_helper'

describe Ownership do

  before(:each) do
    Business.any_instance.stub(:geocode).and_return([1,1]) 
  end
  
  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }
  let(:business) { FactoryGirl.create(:business, created_by: user.id) }
  
  before do
    @ownership = Ownership.find_by("business_id = ? and user_id = ?", business.id, user.id)
  end
  
  subject { @ownership }

  it { should respond_to(:user_id) }
  it { should respond_to(:email_address) }
  it { should respond_to(:business_id) }
  it { should respond_to(:created_by) }
  it { should respond_to(:user) }
  it { should respond_to(:business) }
  its(:business) { should eq business }
  its(:user) { should eq user }
  it { should respond_to(:contactable) }
  it { should respond_to(:phone) }
  it { should respond_to(:position) }

  it { should be_valid }

  describe "when user_id is not present" do
  	before { @ownership.user_id = nil }
  	it { should_not be_valid }
  end

  describe "when email_address is not present" do
    before { @ownership.email_address = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
            foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @ownership.email_address = invalid_address
        expect(@ownership).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @ownership.email_address = valid_address
        expect(@ownership).to be_valid 
      end
    end
  end

  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @ownership.email_address = mixed_case_email
      @ownership.save
      expect(@ownership.email_address).to eq mixed_case_email.downcase
    end
  end

  describe "when business_id is not present" do
  	before { @ownership.business_id = nil }
  	it { should_not be_valid }
  end

  describe "when created_by is not present" do
  	before { @ownership.created_by = nil }
  	it { should_not be_valid }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @ownership.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when user_id and business_id combo is a duplicate" do
  	before do
  		@duplicate_record = business.ownerships.build(user_id: user.id,
                      email_address: "other_address@example.com",
                      created_by: user.id)
  		#@duplicate_record.created_by = other_user.id
  	end
    specify { expect(@duplicate_record).not_to be_valid }
  end
end
