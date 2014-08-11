class ProductsController < ApplicationController
  
  before_action :not_signed_in,               only: [:index, :show, :new, :edit]
  before_action :illegal_action,              only: [:create, :update, :destroy]
  before_action :product_team_member_illegal, only: [:show, :edit, :update, :destroy]
  before_action :team_member,                 only: [:index, :new, :create]

  def index
  	#@business = Business.find(params[:my_business_id])
  	@products = @business.products.order("title")
    session[:genre_select] = nil
    session[:category_select] = nil
    session[:product] = nil
  end

  def new
    session[:product] = nil
  	#@business = Business.find(params[:my_business_id])
  	@product = @business.products.new
    @product.created_by = current_user.id
    @product.currency = @business.currency_code
    @genres = Genre.with_topics
    @categories = Category.with_topics
    @topics = Topic.where("status =?", 1).order('description')
    @methods = TrainingMethod.all.order('position')
    @durations = Duration.all.order('position')
    @lengths = ContentLength.all.order('position')

  end

  def newprod
    @business = Business.find(current_business)
    @product = @business.products.new
    @category = Category.find(session[:category_select])
    @genre = Genre.find(@category.genre_id)
    @topics = @category.topics.where("topics.status = ?", 1).order("topics.description")
    @product.created_by = current_user.id
    @methods = TrainingMethod.all.order('position')
    @durations = Duration.all.order('position')
    @lengths = ContentLength.all.order('position')
  end

  def create
    #@business = Business.find(params[:my_business_id])
    @product = @business.products.build(product_params)
    if @product.save
      session[:category_select] = nil
      flash[:success] = "Successfully created. Please check the details carefully"
      redirect_to product_path(@product)
    else
      @methods = TrainingMethod.all.order('position')
      @durations = Duration.all.order('position')
      @lengths = ContentLength.all.order('position')
      if session[:category_select] == nil
        @product.created_by = current_user.id
        @product.currency = @business.currency_code
        #@genres = Genre.where("status =?", 1).order('position')
        #@categories = Category.where("status =?", 1).order('description')
        @genres = Genre.with_topics
        @categories = Category.with_topics
        @topics = Topic.where("status =?", 1).order('description')
      
        render 'new'
      else
        @category = Category.find(session[:category_select])
        @genre = Genre.find(@category.genre_id)
        @topics = @category.topics.where("topics.status = ?", 1).order("topics.description")
        @product.created_by = current_user.id
        @product.currency = @business.currency_code
        
        render 'newprod'
      end
    end
  end

  def show
    #@product = Product.find(params[:id])
    #@business = Business.find(@product.business_id)
  end

  def edit
    #@product = Product.find(params[:id])
    session[:genre_select] = @product.topic.category.genre_id
    session[:product] = @product.id
    #@business = Business.find(@product.business_id)
    @genres = Genre.with_topics
    @categories = Category.with_topics
    @topics = Topic.where("status =?", 1).order('description')
    @methods = TrainingMethod.all.order('position')
    @durations = Duration.all.order('position')
    @lengths = ContentLength.all.order('position')
  end

  def update
    #@product = Product.find(params[:id])
    if @product.update_attributes(product_params)
      session[:product] = nil
      flash[:success] = "Details updated."
      redirect_to product_path(@product)
    else
      #@business = Business.find(@product.business_id)
      @genres = Genre.with_topics
      @categories = Category.with_topics
      @topics = Topic.where("status =?", 1).order('description')
      @methods = TrainingMethod.all.order('position')
      @durations = Duration.all.order('position')
      @lengths = ContentLength.all.order('position')
      render 'edit'
    end
  end

  def destroy
    #@product = Product.find(params[:id])
    #@business = Business.find(@product.business_id)
    @product.destroy
    flash[:success] = "'#{@product.title}' deleted"
    redirect_to my_business_products_path(@business)
  end

  private

    def product_params
      params.require(:product).permit(:title, :ref_code, :qualification,
                      :training_method_id, :duration_id, :duration_number,
                      :content_length_id, :content_number, :standard_cost,
                      :content, :outcome, :current, :image, :remote_image_url, 
                      :image_cache, :remove_image, :web_link,
                      :topic_id, :created_by)
    end
end
