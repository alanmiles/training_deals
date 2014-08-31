require 'spec_helper'
require 'tod'

describe Event do
  
  before(:each) do
    Business.any_instance.stub(:geocode).and_return([1,1]) 
  end
  
  let!(:user) { FactoryGirl.create(:user) }
  let!(:business) { FactoryGirl.create(:business, created_by: user.id) }
  let!(:genre) { FactoryGirl.create(:genre, description: "Career", created_by: user.id) }
  let!(:category) { FactoryGirl.create(:category, description: "Sales",genre: genre, created_by: user.id) }
  let!(:topic) { FactoryGirl.create(:topic, description: "Phone sales", category: category, created_by: user.id) }
  let!(:training_method) { FactoryGirl.create(:training_method, description: "Training course", event: true) }
  let!(:content_length) { FactoryGirl.create(:content_length) }
  let!(:duration) { FactoryGirl.create(:duration) }
  let!(:product)	{ FactoryGirl.create(:product, business: business, topic: topic, 
  		training_method: training_method, duration: duration, duration_number: 2000,
  		content_length: content_length) }

  describe "A Product with an event-oriented training method" do

	  before do 
	  	@event = product.events.build(
	  					start_date: Date.today + 14,
	  					end_date: Date.today + 34,
	  					start_time: TimeOfDay.new(10, 00).strftime("%H:%M"),
	  					finish_time: TimeOfDay.new(13, 00).strftime("%H:%M"),
	  					price: 100.00,
	  					places_available: 12,
	  					places_sold: 4,
	  					created_by: user.id)
	  end

	  subject { @event }

	  it { should respond_to(:product_id) }
	  it { should respond_to(:start_date) }
	  it { should respond_to(:price) }
	  it { should respond_to(:end_date) }
	  it { should respond_to(:places_available) }
	  it { should respond_to(:places_sold) }
	  it { should respond_to(:start_time) }
	  it { should respond_to(:finish_time) }
	  it { should respond_to(:attendance_days) }
	  it { should respond_to(:time_of_day) }
	  it { should respond_to(:location) }
	  it { should respond_to(:note) }
	  it { should respond_to(:cancelled) }
	  it { should respond_to(:created_by) }
	  it { should respond_to(:product) }
	  its(:product) { should eq product }

	  it { should be_valid }

	  describe "when product_id is not present" do
	    before { @event.product_id = nil }
	    it { should_not be_valid }
	  end

	  describe "when start_date is not present" do
	    before { @event.start_date = nil }
	    it { should_not be_valid }
	  end

	  describe "when end_date is not present" do
	    before { @event.end_date = nil }
	    it { should_not be_valid }
	  end

	  describe "when end_date is earlier than start_date" do
	  	before { @event.end_date = Date.today + 3 }
	  	it { should_not be_valid }
	  end

	  describe "when price is missing" do
	  	before { @event.price = nil }
	  	it { should_not be_valid }
	  end

	  describe "when price is not a numeral" do
	  	before { @event.price = "GBP 5.00" }
	  	it { should_not be_valid }
	  end

	  describe "when price is 0" do
	    before { @event.price = 0 }
	    it { should be_valid }
	  end

	  describe "when places_available is missing" do
	  	before { @event.places_available = nil }
	  	it { should_not be_valid }
	  end

	  describe "when places_sold is missing" do
	  	before { @event.places_sold = nil }
	  	it { should_not be_valid }
	  end

	  describe "when places_available is not a number" do
	  	before { @event.places_available = "Twelve" }
	  	it { should_not be_valid }
	  end

	  describe "when places_sold is not a number" do
	  	before { @event.places_sold = "Zero" }
	  	it { should_not be_valid }
	  end

	  describe "when places_available is not a whole number" do
	  	before { @event.places_available = 3.5 }
	  	it { should_not be_valid }
	  end

	  describe "when places_sold is not a whole number" do
	  	before { @event.places_sold = 3.5 }
	  	it { should_not be_valid }
	  end

	  describe "when places_available is less than zero" do
	  	before { @event.places_available = -2 }
	  	it { should_not be_valid }
	  end

	  describe "when places_sold is less than 0" do
	  	before { @event.places_sold = -2 }
	  	it { should_not be_valid }
	  end

	  describe "when places_available and sold are both 0" do
	  	before do 
	  		@event.places_sold = 0
	  		@event.places_available = 0
	  	end
	  	it { should be_valid }
	  end

	  describe "when places_sold is 0" do
	  	before { @event.places_sold = 0 }
	  	it { should be_valid }
	  end

	  describe "when places_sold is greater than places_available" do
	  	before { @event.places_sold = 13 }
	  	it { should_not be_valid }
	  end

	  describe "when places_available is less than places_sold" do
	  	before { @event.places_available = 3 }
	  	it { should_not be_valid }
	  end

	  pending "no tests yet for date format or validity - but this is catered for using DatePicker"

	  #describe "when start-time is invalid" do
	  #	before { @event.start_time = TimeOfDay.new(25, 40).strftime("%H:%M") }
	  #	it { should_not be_valid }
	  #end

	  pending "no test for invalid start-time - Argument Error thrown"

	  describe "when start-time is not formatted HH:MM" do
	  	before { @event.start_time = TimeOfDay.new(9, 40).strftime("%k:%M") }
	  	it { should_not be_valid }
	  end

	  describe "when start-time has 'AM' or 'PM' added" do
	  	before { @event.start_time = TimeOfDay.new(9, 40).strftime("%H:%M %p") }
	  	it { should_not be_valid }
	  end

	  #describe "when finish-time is invalid" do
	  #	before { @event.finish_time = TimeOfDay.new(25, 40).strftime("%H:%M") }
	  #	it { should_not be_valid }
	  #end

	  pending "no test for invalid end-time - Argument Error thrown"

	  describe "when finish-time is not formatted HH:MM" do
	  	before { @event.finish_time = TimeOfDay.new(9, 40).strftime("%k:%M") }
	  	it { should_not be_valid }
	  end

	  describe "when finish-time has 'AM' or 'PM' added" do
	  	before { @event.finish_time = TimeOfDay.new(9, 40).strftime("%H:%M %p") }
	  	it { should_not be_valid }
	  end

	  describe "when start-time is present but finish-time is not" do
	  	before { @event.finish_time = nil }
	  	it { should_not be_valid }
	  end

	  describe "when finish-time is present but start-time is not" do
	  	before { @event.start_time = nil }
	  	it { should_not be_valid }
	  end

	  describe "when neither start nor finish-time are present" do
	  	before do
	  		@event.start_time = nil
	  		@event.finish_time = nil
	  	end
	  	it { should be_valid }
	  end

	  describe "when location is too long" do
	  	before { @event.location = "a" * 76 }
	    it { should_not be_valid }
	  end

	  describe "when note is too long" do
	  	before { @event.note = "a" * 141 }
	    it { should_not be_valid }
	  end

	  describe "when time of day is from the list selection" do
	  	before { @event.time_of_day = "Morning/Afternoon" }
	  	it { should be_valid }
	  end

	  describe "when time of day is not from the list selection" do
	  	before { @event.time_of_day = "Mornings and afternoons" }
	  	it { should_not be_valid }
	  end

	  describe "when product and start_date are identical" do
	    before do
	      identical_event = @event.dup 
	      identical_event.save
	    end
	    
	    it { should_not be_valid }
	  end

	  describe "when product is identical but not start-date" do
	  	before do
	      identical_product_event = @event.dup
	      identical_product_event.start_date = Date.today + 50 
	      identical_product_event.save
	    end
	    it { should be_valid }
	  end

	  describe "when start-date is identical but not product" do
	  	
	  	let!(:product_2)	{ FactoryGirl.create(:product, business: business, topic: topic, 
	  		training_method: training_method, duration: duration, duration_number: 2000,
	  		content_length: content_length) }

	  	before do
	  		identical_start_event = @event.dup
	  		identical_start_event.product_id = product_2.id
	  		identical_start_event.save
	    end
	    it { should be_valid }
	  end

	  describe "when created_by is not present" do
	    before { @event.created_by = nil }
	    it { should_not be_valid }
	  end

	  describe "when created_by is nil or 0, or empty, or not an integer" do
	    test_values = [ 0, -1, "three", nil, 1.5]
	    test_values.each do |test|
	      before { @event.created_by = test }
	      it { should_not be_valid }
	    end
	  end

	  describe "when created_by is any whole number >= 1" do
	    test_values = [ 1, 1000000]
	    test_values.each do |test|
	      before { @event.created_by = test }
	      it { should be_valid }
	    end
	  end
  end

  describe "A Product with a training method that is not event-oriented" do

  	let!(:non_event_training_method) { FactoryGirl.create(:training_method, 
  		description: "Book", event: false) }
  	let!(:non_event_product)	{ FactoryGirl.create(:product, business: business, 
  		topic: topic, training_method: non_event_training_method, 
  		content_length: content_length) }

  	before do 
	  	@non_event = non_event_product.events.build(
	  					start_date: Date.today + 14,
	  					end_date: Date.today + 34,
	  					created_by: user.id)
	end

	subject { @non_event }

	it { should_not be_valid }

  end
end
