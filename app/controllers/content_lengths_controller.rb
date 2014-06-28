class ContentLengthsController < ApplicationController
  
  before_action :not_admin

  def index
  	@lengths = ContentLength.order('position')
  end

  def new
    @length = ContentLength.new
  end

  def create
    @length = ContentLength.new(content_length_params)
    if @length.save
      flash[:success] = "'#{@length.description}' added"
      redirect_to content_lengths_path
    else
      render 'new'
    end
  end

  def edit
    @length = ContentLength.find(params[:id])
  end

  def update
    @length = ContentLength.find(params[:id])
    if @length.update_attributes(content_length_params)
      flash[:success] = "Updated to '#{@length.description}'"
      redirect_to content_lengths_path
    else
      render 'edit'
    end
  end

  def destroy
    @length = ContentLength.find(params[:id]).destroy
    flash[:success] = "'#{@length.description}' deleted"
    redirect_to content_lengths_path
  end

  def sort
    params[:content_length].each_with_index do |id, index|
      content_length = ContentLength.find(id)
      content_length.update_attribute(:position, index) if content_length
    end
    render nothing: true
  end

  private

		def content_length_params
			params.require(:content_length).permit(:description)
		end
end
