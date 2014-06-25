class StaticPagesController < ApplicationController
  
  	before_action :home_open, only: :home
  	before_action :not_admin, only: :admin_menu

  	def home	
	end

	def about
	end

	def contact
	end

	def admin_menu
	end

	private
		def home_open
			if signed_in? && current_user.admin?
  				redirect_to admin_menu_path 
  			end
  		end

  		def not_admin
  			unless signed_in? && current_user.admin?
  				flash[:notice] = "You are not an authorized administrator."
  				redirect_to root_path
  			end
  		end
end
