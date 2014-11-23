class ExchangeRatesController < ApplicationController
  
  before_action :not_admin

  def index
  	@time_ref = ExchangeRate.last_updated
  	@exchange_rates = ExchangeRate.all.order('currency_code')
    respond_to do |format|
      format.html
      format.csv { send_data @exchange_rates.to_csv }
    end
  end

  def create
  	ExchangeRate.get_latest
  	Product.calculate_dollar_price
    Event.calculate_dollar_price
  	redirect_to exchange_rates_path
  end

  private

    def exchange_rate_params
      params.require(:exchange_rate).permit(:currency_code, :rate )
    end

end
