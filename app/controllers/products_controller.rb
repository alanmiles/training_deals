class ProductsController < ApplicationController
  def index
  	@business = Business.find(params[:my_business_id])
  	@products = @business.products.order("title")
  end

  def new
  	@business = Business.find(params[:my_business_id])
  	@product = @business.products.new
    @product.created_by = current_user.id
    @genres = Genre.where("status =?", 1).order('position')
    @categories = Category.where("status =?", 1).order('description')
    @topics = Topic.where("status =?", 1).order('description')

    #respond_to do |format|
    #  format.js
    #  format.html { redirect_to new_genre_selection_path }
    #end
  end

  def newprod
    @business = Business.find(current_business)
    @product = @business.products.new
    @category = Category.find(session[:category_select])
    @genre = Genre.find(@category.genre_id)
    @topics = @category.topics.where("topics.status = ?", 1).order("topics.description")
    @product.created_by = current_user.id
  end

  def create
    session[:category_select] = nil
  end

  def edit
  end

  private

    def product_params
      params.require(:user).permit(:title, :ref_code, :qualification,
                      :training_method_id, :duration_id, :duration_number,
                      :content_length_id, :content_number, :standard_cost,
                      :content, :outcome, :current, :image, :web_link,
                      :topic_id)
    end
end
