class Admin::BusinessesController < ApplicationController
  
  	before_action :illegal_action, only: :destroy
    before_action :signed_in_user, except: :destroy
    before_action :admin_user 
  	
  	helper_method :sort_column, :sort_direction

	def index
    	@businesses = Business.where("inactive = ?", false)
    		  	.search(params[:search])
            .order(sort_column + " " + sort_direction)
            .page(params[:page]).per(15)
      	#@total = @businesses.search(params[:search]).count
  	end

  	def show
		@business = Business.find(params[:id])
    @ownerships = @business.ownerships
    @founder = User.find(@business.created_by)
	end

	def destroy
    	@business = Business.find(params[:id])
      	@business.destroy
      	flash[:success] = "#{@business.name}, #{@business.city} deleted"
      	redirect_to admin_businesses_url
  	end

  	private

    	def sort_column
      		["LOWER(name)", "city", "country"].include?(params[:sort]) ? params[:sort] : "LOWER(name)"
    	end

    	def sort_direction
      		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    	end 
end
