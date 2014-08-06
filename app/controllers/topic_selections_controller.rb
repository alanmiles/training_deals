class TopicSelectionsController < ApplicationController
  
  def new
  	#@category = Category.find(params[:category_selection_id])
    @category = Category.find(session[:category_select])
  	@genre = Genre.find(@category.genre_id)
  	@topics = @category.topics.where("topics.status = ?", 1).order('topics.description')
  	@product = Product.find(session[:product]) unless session[:product].nil?
    @business = current_business
  end

  def create
    @topic = Topic.find(params[:topic][:id])
  	@product = Product.find(session[:product])
  	@product.update_attributes(topic_id: @topic.id)
  	redirect_to edit_product_path(@product)	
  end
end
