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

    def team_member_valid(business)
      unless valid_team_member?(business)
        flash[:error] = "The page you requested doesn't belong to you!"
        redirect_to current_user
      end
    end

    def illegal_team_member(business)
      unless valid_team_member?(business)
        flash[:error] = "Action not permitted!"
        redirect_to current_user
      end
    end
end
