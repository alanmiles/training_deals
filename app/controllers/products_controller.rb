class ProductsController < ApplicationController
  def index
  	@business = Business.find(params[:my_business_id])
  	@products = @business.products.order("title")
  end

  def new
  	@business = Business.find(params[:my_business_id])
  	@product = @business.products.new
    @genres = Genre.where("status = ?", 1)
    @product.created_by = current_user.id
  end

  def edit
  end
end
