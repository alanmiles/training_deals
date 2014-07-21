class MyBusinessesController < ApplicationController

  before_action :not_signed_in,     only: [:index, :show, :new, :edit]
  before_action :check_ownership,   only: [:show, :edit]
  before_action :illegal_action,    only: [:create, :update, :destroy]
  before_action :wrong_owner_action,  only: [:update, :destroy]

  def index
    @businesses = current_user.businesses.order('name')
  end

  def show
    @owners = @business.users
  end

  def new
  	@business = Business.new
    @business.created_by = current_user.id
  end

  def create
  	@business = Business.new(business_params)
  	create_owner
    if @business.save
      flash[:success] = "Successfully added. Please check all the details carefully."
      redirect_to my_business_path(@business)
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @business.update_attributes(business_params)
      flash[:success] = "'#{@business.name}' updated"
      redirect_to my_business_path(@business)
    else
      render 'edit'
    end
  end

  def destroy
    @business.destroy
    flash[:success] = "'#{@business.name}' in '#{@business.city} deleted"
    redirect_to my_businesses_path
  end

  private

  	def business_params
			params.require(:business).permit(:name, :description, :street_address, 
        :city, :state, :postal_code, :country, :latitude, :longitude, :hide_address, 
        :phone, :alt_phone, :email, :website, :logo, :image_1, :image_2, :inactive, :inactive_from)
	  end

	  def create_owner
		  @business.created_by = current_user.id
	  end

    def not_signed_in
      unless signed_in?
        store_location
        flash[:notice] = "Page not accessible. Please sign in or sign up."
        redirect_to signin_url
      end
    end

    def check_ownership
      @business = Business.find(params[:id])
      if signed_in?
        unless valid_team_member?(@business)
          flash[:error] = "The page you requested doesn't belong to you!"
          redirect_to current_user
        end
      end
    end

    def illegal_action
      unless signed_in?
        flash[:notice] = "Action not permitted!"
        redirect_to(root_url)
      end
    end

    def wrong_owner_action
      @business = Business.find(params[:id])
      if signed_in?
        unless valid_team_member?(@business)
          flash[:error] = "Action not permitted!"
          redirect_to current_user
        end
      end
    end
end
