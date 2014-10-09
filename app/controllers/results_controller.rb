class ResultsController < ApplicationController
  
  def index
    session[:genre] = params[:genre][:genre_id]
    session[:category] = params[:category][:category_id]
    session[:topic] = params[:topic][:topic_id]
    session[:method] = nil
#    @products = find_products.paginate(per_page: 3, page: params[:page])
    @products = find_products
    @search_string = find_search_string
#    @t_methods = @products.t_methods
    @t_methods = TrainingMethod.product_selection(@products)
    respond_to do |format|
      format.html
      format.json { render json: @products }
      format.js
    end
  end

  def filter_by_method
    session[:method] = params[:method_id]
 #   @products = find_products.paginate(per_page: 3, page: params[:pr_page])
    @products = find_products
    respond_to do |format|
      format.html 
      format.json { render json: @products }
      format.js
    end
  end

  def show
  end

  private 

    def find_products
      if session[:topic] == ""
        if session[:category] == ""
          @genre = Genre.find(session[:genre])
          products = @genre.active_products
        else
          @category = Category.find(session[:category])
          products = @category.active_products
        end
      else
        @topic = Topic.find(session[:topic])
        products = @topic.active_products
      end
      products = products.where("training_method_id = ?", session[:method]) unless session[:method].nil? || session[:method].blank?
      products
    end

    def find_search_string
      if session[:topic] == ""
        if session[:category] == ""
          @genre = Genre.find(session[:genre])
          search_string = @genre.description
        else
          @category = Category.find(session[:category])
          search_string = @category.classification
        end
      else
        @topic = Topic.find(session[:topic])
        search_string = @topic.classification
      end
    end
end
