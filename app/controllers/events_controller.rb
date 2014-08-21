class EventsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
  	@business = Business.find(params[:my_business_id])
  	@events = @business.events.order(sort_column + " " + sort_direction)
  end

  def new
  	@business = Business.find(params[:my_business_id])
  	@event = @business.events.new
    @event.created_by = current_user.id
    @products = @business.products.schedulable
    @checked_days = []
    @periods = Event.day_periods
    @selected_period = nil
  end

  def create
    @prod_id = params[:event][:product_id]
    unless @prod_id.nil? || @prod_id.empty?
      @business = Business.find(params[:my_business_id])
    	@product = Product.find(@prod_id)
      @event = @product.events.build(event_params)
      attended = []
      unless params[:weekdays].nil?
        params[:weekdays].each do |day|
          attended << day if day.present?
        end
        @event.attendance_days = attended.split.join(", ")
      end
      @selected_period = params[:event][:time_of_day]
      if @event.save
        	flash[:success] = "Successfully created. Please check the details carefully"
        	redirect_to event_path(@event)
      else
          @event.created_by = current_user.id
        	@products = @business.products.schedulable
          if @selected_period.nil?
            @periods = Event.day_periods
          else
            @periods = Event.day_periods_with_blank
          end
          @checked_days = []
          unless params[:weekdays].nil?
            params[:weekdays].each do |day|
              @checked_days << day
            end
          end
        	render 'new'
    	end
    else
      @business = Business.find(params[:my_business_id])
      @event = @business.events.new
      @event.created_by = current_user.id
      @periods = Event.day_periods
      @products = @business.products.schedulable
      flash.now[:error] = "Please start again - and make sure you 
          select a product in the 'Relating to' box."
      render 'new'
    end
  end

  def show
    @event = Event.find(params[:id])
    @product = Product.find(@event.product_id)
    @business = Business.find(@product.business_id)
    @owners = @business.contactable_users
  end

  def edit
    @event = Event.find(params[:id])
  end

  private

    def event_params
      params.require(:event).permit(:product_id, :start_date, :end_date, :attendance_days, :created_by,
                      :weekdays, :start_time, :finish_time, :time_of_day, :location, :note )
    end

    def sort_column
    	["products.title", "start_date", "end_date"].include?(params[:sort]) ? params[:sort] : "start_date"
    end

    def sort_direction
    	%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end
end
