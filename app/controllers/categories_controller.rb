class CategoriesController < ApplicationController
  
  before_action :not_admin

  def index
  	@genre = Genre.find(params[:genre_id])
  	@categories = @genre.categories.where("categories.status = ?", 1).order('categories.description') 
  end

  def new
    @genre = Genre.find(params[:genre_id])
    @category = @genre.categories.new
    @category.status = 1
  end

  def create
    @genre = Genre.find(params[:genre_id])
    @category = @genre.categories.build(category_params)
    if @category.save
      flash[:success] = "'#{@category.description}' added to the '#{@genre.description}' genre"
      redirect_to genre_categories_url(@genre)
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
    @genre = Genre.find(@category.genre_id)
  end

  def update
    @category = Category.find(params[:id])
    @genre = Genre.find(@category.genre_id)
    if @category.update_attributes(category_params)
      flash[:success] = "Updated to '#{@category.description}'"
      redirect_to genre_categories_url(@genre)
    else
      render 'edit'
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @genre = Genre.find(@category.genre_id)
    @category.destroy
    flash[:success] = "Deleted '#{@category.description}' in the #{@genre.description} genre."
    redirect_to genre_categories_path(@genre)
  end

  private

    def category_params
      params.require(:category).permit(:description, :status)
    end
end
