class Admin::UsersController < ApplicationController
  
  	before_action :signed_in_user
  	before_action :admin_user

  	helper_method :sort_column, :sort_direction

	def index
    	@users = User.search(params[:search])
              .order(sort_column + " " + sort_direction)
              .paginate(per_page: 15, page: params[:page])
      @total = @users.search(params[:search]).count
  	end

  	def show
		@user = User.find(params[:id])
		@businesses = @user.businesses
	end

	def destroy
    	@user = User.find(params[:id])
    	if @user == current_user
      		flash[:notice] = "You're not allowed to delete yourself!"
      		redirect_to root_url
    	else
      		@user.destroy
      		flash[:success] = "#{@user.name} deleted"
      		redirect_to admin_users_url
    	end
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
      		["LOWER(name)", "city", "country", "email"].include?(params[:sort]) ? params[:sort] : "LOWER(name)"
    	end

    	def sort_direction
      		%w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    	end 
end
