class GenreSelectionsController < ApplicationController
  def new
  	session[:category_select] = nil
  	@genre = Genre.find(session[:genre_select]) unless session[:genre_select].nil?
  	@genres = Genre.where("status = ?", 1).order('position') 
  	@product = Product.find(session[:product]) unless session[:product].nil?
    @business = current_business
  end

  def create
  	@genre = Genre.find(params[:genre][:id])
  	session[:genre_select] = @genre.id
  	redirect_to new_genre_selection_category_selection_path(@genre)
  end
end
