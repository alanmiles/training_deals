class ExchangeRatesController < ApplicationController
  
  before_action :not_admin

  def index
  	@time_ref = ExchangeRate.last_updated
  	@exchange_rates = ExchangeRate.all.order('currency_code')
  end

  def create
  	ExchangeRate.get_latest
  	Product.calculate_dollar_price
    Event.calculate_dollar_price
  	redirect_to exchange_rates_path
  end

end
