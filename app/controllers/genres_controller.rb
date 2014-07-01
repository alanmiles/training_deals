class GenresController < ApplicationController
  
  before_action :not_admin
  
  def index
  	@genres = Genre.where("status = ?", 1).order('position') 
  end

  def new
    @genre = Genre.new
    @genre.status = 1
  end

  def create
    @genre = Genre.new(genre_params)
    if @genre.save
      flash[:success] = "'#{@genre.description}' added"
      redirect_to genres_path
    else
      render 'new'
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def update
    @genre = Genre.find(params[:id])
    if @genre.update_attributes(genre_params)
      flash[:success] = "Updated to '#{@genre.description}'"
      redirect_to genres_path
    else
      render 'edit'
    end
  end

  def destroy
    @genre = Genre.find(params[:id]).destroy
    flash[:success] = "'#{@genre.description}' deleted"
    redirect_to genres_path
  end

  def sort
    params[:genre].each_with_index do |id, index|
      genre = Genre.find(id)
      genre.update_attribute(:position, index) if genre
    end
    render nothing: true
  end

  private

		def genre_params
			params.require(:genre).permit(:description, :status)
		end
end
