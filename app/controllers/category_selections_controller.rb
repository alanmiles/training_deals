class CategorySelectionsController < ApplicationController
  def new
  	@genre = Genre.find(params[:genre_selection_id])
  	@categories = @genre.categories.where("categories.status = ?", 1).order('categories.description')
  end

  def create
  	@category = Category.find(params[:category][:id])
  	session[:category_select] = @category.id
  	redirect_to newprod_new_my_business_product_path(current_business)
  end
end
