class Admin::BusinessesController < ApplicationController
  
  	before_action :signed_in_user
  	before_action :admin_user

  	helper_method :sort_column, :sort_direction

	def index
    	@businesses = Business.where("inactive = ?", false)
    		  	.search(params[:search])
              	.order(sort_column + " " + sort_direction)
              	.paginate(per_page: 15, page: params[:page])
      	@total = @businesses.search(params[:search]).count
  	end

  	def show
		@business = Business.find(params[:id])
    @ownerships = @business.ownerships
	end

	def destroy
    	@business = Business.find(params[:id])
      	@business.destroy
      	flash[:success] = "#{@business.name}, #{@business.city} deleted"
      	redirect_to admin_businesses_url
  	end

  	private

    	def signed_in_user
      		unless signed_in?
        		store_location
        		redirect_to signin_url, notice: "Page not accessible. Please sign in or sign up."
      		end
    	end

    	def admin_user
      		unless current_user.admin?
        		flash[:error] = "Permission denied."
        		redirect_to(root_url) 
      		end
    	end

    	def sort_column
      		["LOWER(name)", "city", "country"].include?(params[:sort]) ? params[:sort] : "LOWER(name)"
    	end

    	def sort_direction
      		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    	end 
end
