require 'spec_helper'

describe ExchangeRate do
  
  before { @exchange_rate = ExchangeRate.new(currency_code: "USD", rate: 1) }

  subject { @exchange_rate }

  it { should respond_to(:currency_code) }
  it { should respond_to(:rate) }
  it { should be_valid }

  describe "when currency_code is not present" do
  	before { @exchange_rate.currency_code = " "}
  	it { should_not be_valid }
  end

  describe "when rate is not present" do
  	before { @exchange_rate.rate = nil }
  	it { should_not be_valid }
  end

  describe "when currency_code is too long" do
  	before { @exchange_rate.currency_code = "A" * 4 }
  	it { should_not be_valid }
  end

  describe "when currency_code is a duplicate" do
  	before do
  		duplicate_record = @exchange_rate.dup 
  		duplicate_record.currency_code = @exchange_rate.currency_code.downcase
  		duplicate_record.save
  	end
  	
  	it { should_not be_valid }
  end

  describe "when rate is not a number" do
  	before { @exchange_rate.rate = "One" }
  	it { should_not be_valid }
  end

  describe "when rate is 0" do
  	before { @exchange_rate.rate = 0 }
  	it { should_not be_valid }
  end



end
