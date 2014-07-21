class MyBusinessesController < ApplicationController

  before_action :not_signed_in,     only: [:index, :show, :new, :edit]
  before_action :illegal_action,    only: [:create, :update, :destroy]
  before_action :check_ownership,   only: [:show, :edit, :update, :destroy]

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
end
