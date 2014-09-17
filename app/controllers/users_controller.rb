class UsersController < ApplicationController
  
  before_action :signed_in_user,  only: [:index, :edit, :update, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: [:index, :destroy]
  before_action :duplicate_user,  only: [:new, :create]

	def index
    @users = User.paginate(page: params[:page]).order("name")
  end

  def show
		@user = User.find(params[:id])
	end

  def new
		@user = User.new
    @password_text = "At least 6 characters/numbers. Make it hard to guess."
    @confirm_text = "Repeat password"
	end

	def create
		@user = User.new(user_params)
    @user.latitude = params[:lat]
    @user.longitude = params[:lng]
    @user.city = params[:locality]
    @user.country = params[:country]
    @user.location = params[:geocomplete]
    @status = params[:loctn_status]
    if @status == "Fail"
      flash.now[:error] = "The location you entered wasn't recognized by Google Maps. Please try again."
      @user.location = ""
      render 'new'
    else
      if @user.save
        sign_in @user
        flash[:success] = "Welcome to HROOMPH."
  			redirect_to @user
  		else
        render 'new'
  		end
    end
	end

  def edit
    @password_text = "Your usual password"
    @confirm_text = "Repeat password"
  end

  def update
    @user.latitude = params[:lat]
    @user.longitude = params[:lng]
    @user.city = params[:locality]
    @user.country = params[:country]
    @status = params[:loctn_status]
    if @status == "Fail"
      flash.now[:error] = "The location you entered wasn't recognized by Google Maps. Please try again."
      @user.latitude = params[:lat]
      @user.longitude = params[:lng]
      @user.city = params[:locality]
      @user.country = params[:country]
     # @user.location = ""
      render 'edit'
    else
      if @user.update_attributes(user_params)
        place = params[:geocomplete]
        @user.update_attributes(location: place)
        flash[:success] = "Profile updated"
        redirect_to @user
      else
        @user.latitude = params[:lat]
        @user.longitude = params[:lng]
        @user.city = params[:locality]
        @user.country = params[:country]
        @user.location = params[:geocomplete]
        render 'edit'
      end
    end
  end

  def destroy
    @user = User.find(params[:id])
    if @user == current_user
      flash[:notice] = "You're not allowed to delete yourself!"
      redirect_to root_url
    else
      @user.destroy
      flash[:success] = "User deleted"
      redirect_to users_url
    end
  end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password,
											:password_confirmation, :latitude, :longitude, :location,
                      :city, :country)
		end

    # Before filters

    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Page not accessible. Please sign in or sign up."
      end
    end

    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        flash[:error] = "Permission denied"
        redirect_to(root_url)
      end
    end

    def admin_user
      unless current_user.admin?
        flash[:error] = "Permission denied."
        redirect_to(root_url) 
      end
    end 

    def duplicate_user
      if signed_in?
        flash[:notice] = "You've already created your user account."
        redirect_to root_url 
      end
    end
end
