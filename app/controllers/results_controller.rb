class ResultsController < ApplicationController
  
  def index
    if params[:topic].try(:[],:topic_id) && params[:topic][:topic_id] != ""
      @topic = Topic.find(params[:topic][:topic_id])
      @products = @topic.active_products.paginate(per_page: 3, page: params[:page])
    else
      if params[:category][:category_id]  && params[:category][:category_id] != ""
        @category = Category.find(params[:category][:category_id])
        @products = @category.active_products.paginate(per_page: 3, page: params[:page])
      else
        if params[:genre][:genre_id]  && params[:genre][:genre_id] != ""
          @genre = Genre.find(params[:genre][:genre_id])
          @products = @genre.active_products.paginate(per_page: 3, page: params[:page])
        else
          @products = Product.all
        end
      end
    end
  end

  def show
  end
end
