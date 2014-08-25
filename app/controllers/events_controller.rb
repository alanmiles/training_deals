class EventsController < ApplicationController
  
  before_action :not_signed_in,               only: [:index, :show, :new, :edit]
  before_action :illegal_action,              only: [:create, :update, :destroy]
  before_action :event_team_member_illegal, only: [:show, :edit, :update, :destroy]
  before_action :team_member,                 only: [:index, :new, :create]

  helper_method :sort_column, :sort_direction

  def index
  	#@business = Business.find(params[:my_business_id])
  	@events = @business.current_and_future_events.order(sort_column + " " + sort_direction)
  end

  def new
  	#@business = Business.find(params[:my_business_id])
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
      #@business = Business.find(params[:my_business_id])
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
      #@business = Business.find(params[:my_business_id])
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
    #@event = Event.find(params[:id])
    #@product = Product.find(@event.product_id)
    #@business = Business.find(@product.business_id)
    @owners = @business.contactable_users
  end

  def edit
    #@event = Event.find(params[:id])
    #@product = Product.find(@event.product_id)
    #@business = Business.find(@product.business_id)
    @checked_days = []
    unless @event.attendance_days.nil?
      @attdays = @event.attendance_days.split(', ')
      @attdays.each do |day|
          @checked_days << day
      end
    end
    @selected_period = @event.time_of_day
    if @selected_period.blank?
      @periods = Event.day_periods
    else
      @periods = Event.day_periods_with_blank
    end
  end

  def update
    #@event = Event.find(params[:id])
    #@product = Product.find(@event.product_id)
    attended = []
    unless params[:weekdays].nil?
      params[:weekdays].each do |day|
        attended << day if day.present?
      end
      @event.attendance_days = attended.split.join(", ")
    end
    if @event.update_attributes(event_params)
      flash[:success] = "Updated event details"
      redirect_to event_path(@event)
    else
      @periods = Event.day_periods_with_blank
      @selected_period = @event.time_of_day
      @checked_days = []
      unless params[:weekdays].nil?
        params[:weekdays].each do |day|
          @checked_days << day
        end
      end
      render 'edit'
    end
  end

  def destroy
    #@event = Event.find(params[:id])
    #@product = Product.find(@event.product_id)
    #@business = Business.find(@product.business_id)
    @event.destroy
    if @event.end_date < Date.today
      flash[:success] = "Completed event starting #{@event.start_date.strftime('%d-%b-%y')} for '#{@product.title}' deleted"
      if @business.has_previous_events?
        redirect_to my_business_previous_events_path(@business)
      else
        redirect_to my_business_events_path(@business)
      end
    else
      flash[:success] = "Event starting #{@event.start_date.strftime('%d-%b-%y')} for '#{@product.title}' deleted"
      redirect_to my_business_events_path(@business)
    end
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
