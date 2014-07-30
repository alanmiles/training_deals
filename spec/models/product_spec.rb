require 'spec_helper'

describe Product do
  
  before(:each) do
    Business.any_instance.stub(:geocode).and_return([1,1]) 
  end
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:business) { FactoryGirl.create(:business, created_by: user.id) }
  let(:genre) { FactoryGirl.create(:genre, description: "Career", created_by: user.id) }
  let(:category) { FactoryGirl.create(:category, description: "Sales",genre: genre, created_by: user.id) }
  let(:topic) { FactoryGirl.create(:topic, description: "Phone sales", category: category, created_by: user.id) }
  let(:training_method) { FactoryGirl.create(:training_method) }
  let(:content_length) { FactoryGirl.create(:content_length) }
  let(:duration) { FactoryGirl.create(:duration) }

  before do 
  	@product = business.products.build(
  					title: "Cold calling",
  					topic_id: topic.id,
  					training_method_id: training_method.id,
  					content_number: 1,
  					content_length_id: content_length.id,
  					#currency: "GBP",
  					standard_cost: 100.00,
  					content: "Course content",
  					outcome: "Course outcome",
  					created_by: user.id)
  end

  subject { @product}

  it { should respond_to(:business_id) }
  it { should respond_to(:title) }
  it { should respond_to(:ref_code) }
  it { should respond_to(:topic_id) }
  it { should respond_to(:qualification) }
  it { should respond_to(:training_method_id) }
  it { should respond_to(:duration_id) }
  it { should respond_to(:duration_number) }
  it { should respond_to(:content_length_id) }
  it { should respond_to(:content_number) }
  it { should respond_to(:currency) }
  it { should respond_to(:standard_cost) }
  it { should respond_to(:content) }
  it { should respond_to(:outcome) }
  it { should respond_to(:current) }
  it { should respond_to(:image) }
  it { should respond_to(:web_link) }
  it { should respond_to(:created_by) }

  it { should respond_to(:business) }
  its(:business) { should eq business }
  it { should respond_to(:topic) }
  its(:topic) { should eq topic }
  it { should respond_to(:training_method) }
  its(:training_method) { should eq training_method }

  it { should be_valid }

  describe "when business_id is not present" do
    before { @product.business_id = nil }
    it { should_not be_valid }
  end

  #describe "when business association does not exist" do
  #  before { @product.business_id = @product.business_id + 1 }
  #  it { should_not be_valid }
  #end

  describe "when title is not present" do
    before { @product.title = " " }
    it { should_not be_valid }
  end

  describe "when title is too long" do
    before { @product.title = "a" * 76 }
    it { should_not be_valid }
  end

  describe "when ref_code is too long" do
    before { @product.ref_code = "a" * 21 }
    it { should_not be_valid }
  end

  describe "when ref_code is not present" do
    before { @product.ref_code = " " }
    it { should be_valid }
  end

  describe "when topic_id is not present" do
    before { @product.topic_id = nil }
    it { should_not be_valid }
  end

  describe "when topic association does not exist" do
    before { @product.topic_id = @product.topic_id + 1 }
    it { should_not be_valid }
  end

  describe "when qualification is too long" do
    before { @product.qualification = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when training_method_id is not present" do
    before { @product.training_method_id = nil }
    it { should_not be_valid }
  end

  describe "when training_method association does not exist" do
    before { @product.training_method_id = @product.training_method_id + 1 }
    it { should_not be_valid }
  end

  describe "when duration_id is added" do
    before do
      @product.duration_id = duration.id
      @product.duration_number = 1
    end
    it { should be_valid}
  end

  describe "when duration_type is added correctly" do
    before do
      @product.duration_id = duration.time_unit
      @product.duration_number = 1
    end
    it { should_not be_valid }
  end

  describe "when duration_type is present but duration_number is not" do
    before { @product.duration_id = duration.id }
    it { should_not be_valid }
  end

  describe "when duration_number is present but duration-type is not" do
    before { @product.duration_number = 1 }
    it { should_not be_valid }
  end

  describe "when content_length_id is present but content_number is not" do
    before { @product.content_number = nil }
    it { should_not be_valid }
  end

  describe "when content_number is present but content_length_id is not" do
    before { @product.content_length_id = nil }
    it { should_not be_valid }
  end

  describe "when neither content_number nor content_length_id are present" do
    before do
      @product.content_number = nil
      @product.content_length_id = nil 
    end
    it { should be_valid }
  end

  describe "currency field" do
    it "should auto-calculate value on create" do
      @product.save
      expect(@product.currency).to eq business.currency_code
     end
  end

  describe "when standard_cost is not present" do
    before { @product.standard_cost = nil }
    it { should_not be_valid }
  end

  describe "when standard_cost is 0" do
    before { @product.standard_cost = 0 }
    it { should be_valid }
  end

  describe "when content is not present" do
    before { @product.content = " " }
    it { should_not be_valid }
  end

  describe "when content is too long" do
    before { @product.content = "a" * 126 }
    it { should_not be_valid }
  end

  describe "when outcome is not present" do
    before { @product.outcome = " " }
    it { should_not be_valid }
  end

  describe "when outcome is too long" do
    before { @product.outcome = "a" * 126 }
    it { should_not be_valid }
  end

  describe "when created_by is not present" do
    before { @product.created_by = nil }
    it { should_not be_valid }
  end

  describe "when created_by is nil or 0, or empty, or not an integer" do
    test_values = [ 0, -1, "three", nil, 1.5]
    test_values.each do |test|
      before { @product.created_by = test }
      it { should_not be_valid }
    end
  end

  describe "when created_by is any whole number >= 1" do
    test_values = [ 1, 1000000]
    test_values.each do |test|
      before { @product.created_by = test }
      it { should be_valid }
    end
  end

  describe "when business, topic and title are identical" do
    before do
      identical_product = @product.dup 
      identical_product.save
    end
    
    it { should_not be_valid }
  end

  describe "when product is a duplicate, though case of title is different" do
    before do
      identical_product_title = @product.dup 
      identical_product_title.title = @product.title.upcase
      identical_product_title.save
    end
    
    it { should_not be_valid }
  end


  describe "when business and title are the same but topic is different" do
    let(:topic_2) { FactoryGirl.create(:topic, description: "Business sales", category: category, created_by: user.id) }

    before do
      product_with_different_topic = @product.dup 
      product_with_different_topic.topic_id = topic_2.id
      product_with_different_topic.save
    end
    
    it { should be_valid }
  end

  describe "when title and topic are the same but business is different" do
    let!(:business_2) { FactoryGirl.create(:business, created_by: user.id) }
    before do
      product_with_different_business = @product.dup 
      product_with_different_business.business_id = business_2.id
      product_with_different_business.save
    end
    
    it { should be_valid }
  end
end
