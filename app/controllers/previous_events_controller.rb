class PreviousEventsController < ApplicationController
  
  before_action :not_signed_in,               only: :index
  before_action :team_member,                 only: :index

  helper_method :sort_column, :sort_direction

  def index
	  	@business = Business.find(params[:my_business_id])
	  	@events = @business.previous_events.search(params[:search])
          .order(sort_column + " " + sort_direction)
          .paginate(per_page: 15, page: params[:page])
  end

  private

  	def sort_column
    	["products.title", "start_date", "end_date"].include?(params[:sort]) ? params[:sort] : "start_date"
    end

    def sort_direction
    	%w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
    end
end
