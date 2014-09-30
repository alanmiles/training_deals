class StaticPagesController < ApplicationController
  
  	before_action :home_open, only: :home
  	before_action :not_admin, only: :admin_menu

  	def home
      @genres = Genre.with_topics
      @categories = Category.with_topics.where("categories.genre_id =?", Genre.first)
      @topics = Topic.where("status =? and category_id=?", 1, @categories.first)	
  	end

  	def about
  	end

  	def contact
  	end

  	def admin_menu
  	end

    def select_categories
      @categories = Category.where("genre_id = ? and status = ?", params[:genre_id], 1)
      respond_to do |format|
        format.js
      end
    end

    def select_topics
      @topics = Topic.where("category_id = ? and status = ?", params[:category_id], 1).order("description")
      respond_to do |format|
        format.js
      end
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
