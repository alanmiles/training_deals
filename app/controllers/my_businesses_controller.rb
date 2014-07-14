class MyBusinessesController < ApplicationController

  def index
  	@businesses = Business.where("created_by = ?", current_user.id).order('name') 
  end

  def show
  	@business = Business.find(params[:id])
  end

  def new
  	@business = Business.new
    @business.created_by = current_user.id
  end

  def create
  	@business = Business.new(business_params)
  	create_owner
    #capitals_locality
    if @business.save
      flash[:success] = "Successfully added. Please check all the details carefully."
      redirect_to my_business_path(@business)
    else
      render 'new'
    end
  end

  def edit
  	@business = Business.find(params[:id])
  end

  def update
  	@business = Business.find(params[:id])
    #inactive_date if @business.inactive_changed?
    if @business.update_attributes(business_params)
      flash[:success] = "'#{@business.name}' updated"
      redirect_to my_business_path(@business)
    else
      render 'edit'
    end
  end

  def destroy
  	@business = Business.find(params[:id]).destroy
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

  #def inactive_date
  #  if @business.inactive?
  #    @business.inactive_from = Date.today
  #  else
  #    @business.inactive_from = nil
  #  end
  #end
  #def capitals_locality
  #  @names = @business.locality.split
  #  @names.map!(&:capitalize)
  #  @valid_name = @names.join(" ")
  #  @business.locality = @valid_name
  #end

end
