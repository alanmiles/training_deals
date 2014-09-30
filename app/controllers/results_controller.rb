class ResultsController < ApplicationController
  
  def index
  	@genre = Genre.find(params[:genre][:genre_id])
  	@category = Category.find(params[:category][:category_id])
  	#@topic = Topic.find(params[:topic][:category_id])
  	#@products = Product.where("topic_id =?", @topic)
  end

  def show
  end
end
