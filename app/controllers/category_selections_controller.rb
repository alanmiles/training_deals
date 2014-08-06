class CategorySelectionsController < ApplicationController
  def new
  	if session[:genre_select].nil?
      @genre = Genre.find(params[:genre_selection_id])
      session[:genre_select] = @genre.id
    else
      @genre = Genre.find(session[:genre_select])
    end
    @category = Category.find(session[:category_select]) unless session[:category_select].nil?
  	@categories = @genre.categories.where("categories.status = ?", 1).order('categories.description')
  	@product = Product.find(session[:product]) unless session[:product].nil?
    @business = current_business
  end

  def create
  	@category = Category.find(params[:category][:id])
  	session[:category_select] = @category.id
  	if session[:product].nil?
  		redirect_to newprod_new_my_business_product_path(current_business)
  	else
  		redirect_to new_category_selection_topic_selection_path(@category)
  	end
  end
end
