class DurationsController < ApplicationController
  
  before_action :not_admin
  
  def index
  	@durations = Duration.all.order('created_at')
  end

  def new
    @duration = Duration.new
  end

  def create
    @duration = Duration.new(duration_params)
    if @duration.save
      flash[:success] = "'#{@duration.time_unit}' added"
      redirect_to durations_path
    else
      render 'new'
    end
  end

  def edit
    @duration = Duration.find(params[:id])
  end

  def update
    @duration = Duration.find(params[:id])
    if @duration.update_attributes(duration_params)
      flash[:success] = "Updated to '#{@duration.time_unit}'"
      redirect_to durations_path
    else
      render 'edit'
    end
  end

  def destroy
    @duration = Duration.find(params[:id]).destroy
    flash[:success] = "'#{@duration.time_unit}' deleted"
    redirect_to durations_path
  end

  private

		def duration_params
			params.require(:duration).permit(:time_unit)
		end

end
 