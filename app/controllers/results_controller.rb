class ResultsController < ApplicationController
  
  def index
  	@genre = Genre.find(params[:genre][:genre_id])
  	@category = Category.find(params[:category][:category_id])
  	@topic = Topic.find(params[:topic][:topic_id]) unless params[:topic][:topic_id].empty?
  end

  def show
  end
end
