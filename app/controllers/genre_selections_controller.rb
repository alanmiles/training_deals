class GenreSelectionsController < ApplicationController
  def new
  	session[:category_select] = nil
  	@genres = Genre.where("status = ?", 1).order('position') 
  end

  def create
  	@genre = Genre.find(params[:genre][:id])
  	redirect_to new_genre_selection_category_selection_path(@genre)
  end
end
