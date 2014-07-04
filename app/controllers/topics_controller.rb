class TopicsController < ApplicationController
  
  before_action :not_admin
  
  def index
  	@category = Category.find(params[:category_id])
  	@genre = Genre.find(@category.genre_id)
  	@topics = @category.topics.where("topics.status = ?", 1).order('topics.description') 
  end

  def new
    @category = Category.find(params[:category_id])
    @genre = Genre.find(@category.genre_id)
    @topic = @category.topics.new
    @topic.status = 1
  end

  def create
    @category = Category.find(params[:category_id])
    @genre = Genre.find(@category.genre_id)
    @topic = @category.topics.build(topic_params)
    if @topic.save
      flash[:success] = "'#{@topic.description}' 
      	added to the '#{@category.description}' category"
      redirect_to category_topics_url(@category)
    else
      render 'new'
    end
  end

  def edit
  	@topic = Topic.find(params[:id])
    @category = Category.find(@topic.category_id)
    @genre = Genre.find(@category.genre_id)
  end

  def update
    @topic = Topic.find(params[:id])
    @category = Category.find(@topic.category_id)
    @genre = Genre.find(@category.genre_id)
    if @topic.update_attributes(topic_params)
      flash[:success] = "Updated to '#{@topic.description}'"
      redirect_to category_topics_url(@category)
    else
      render 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:id])
    @category = Category.find(@topic.category_id)
    @genre = Genre.find(@category.genre_id)
    @topic.destroy
    flash[:success] = "Deleted '#{@topic.description}' in the #{@category.description} category."
    redirect_to category_topics_path(@category)
  end

  private

    def topic_params
      params.require(:topic).permit(:description, :status)
    end
end
