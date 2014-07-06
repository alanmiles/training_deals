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
  			if signed_in?
          if current_user.admin?
    				redirect_to admin_menu_path
          else
            redirect_to current_user
          end
    		end
    	end


end
