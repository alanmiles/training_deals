class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  private
 
   	def not_admin
        unless signed_in? && current_user.admin?
          flash[:notice] = "You are not an authorized administrator."
          redirect_to root_path
        end
    end

    def not_signed_in
      unless signed_in?
        store_location
        flash[:notice] = "Page not accessible. Please sign in or sign up."
        redirect_to signin_url
      end
    end

    def illegal_action
      unless signed_in?
        flash[:notice] = "Action not permitted!"
        redirect_to(root_url)
      end
    end

    def check_ownership
      @business = Business.find(params[:id])
      if signed_in?
        team_member_valid(@business)
      end
    end

    def team_member_valid(business)
      unless valid_team_member?(business)
        if request.get?
          flash[:error] = "The page you requested doesn't belong to you!"
        else
          flash[:error] = "Action not permitted!"
        end
        redirect_to current_user
      end
    end

    def team_member
      if signed_in?
        @business = Business.find(params[:my_business_id])
        team_member_valid(@business)
      end
    end

    def team_member_illegal
      if signed_in?
        @ownership = Ownership.find(params[:id])
        @business = Business.find(@ownership.business_id)
        team_member_valid(@business)
      end
    end
end
