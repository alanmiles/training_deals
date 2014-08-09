class OwnershipsController < ApplicationController
  
  before_action :not_signed_in,         only: [:index, :new, :edit]
  before_action :illegal_action,        only: [:create, :update, :destroy]
  before_action :team_member,           only: [:index, :new, :create]
  before_action :team_member_illegal,   only: [:edit, :update, :destroy]
  
  def index
  	@ownerships = @business.ownerships.order("position")
  end

  def new
    @ownership = @business.ownerships.new
    @ownership.created_by = current_user.id
  end

  def create
    @ownership = @business.ownerships.build(ownership_params)
    @member = User.find_by(email: params[:ownership][:email_address])
    if @member.nil?
      flash.now[:error] = "Sorry, we can't find this person in the HROOMPH listings.  
          Please check that he/she has signed up to HROOMPH with this email address."
      @ownership.created_by = current_user.id
      render 'new'
    else 
      @ownership.user_id = @member.id
      if @ownership.save
        flash[:success] = "#{@ownership.user.name} added to the team."
        redirect_to my_business_ownerships_url(@business)
      else
        @ownership.created_by = current_user.id
        render 'new'
      end
    end
  end

  def edit
  end

  def update
    if @ownership.update_attributes(ownership_params)
      flash[:success] = "#{@ownership.user.name} updated."
      redirect_to my_business_ownerships_path(@business)
    else
      render 'edit'
    end
  end

  def destroy
    if @business.ownerships.count > 1
      @ownership.destroy
      if @ownership.user_id == current_user.id
        flash[:success] = "You've taken yourself out of the team at #{@business.name}, #{@business.city}."
        redirect_to my_businesses_path
      else
        flash[:success] = "Removed #{@ownership.user.name} from the team."
        redirect_to my_business_ownerships_path(@business)
      end
    else
      flash[:notice] = "Not removed! There has to be at least one team member."
      redirect_to my_business_ownerships_path(@business)
    end
  end

  def sort
    params[:ownership].each_with_index do |id, index|
      ownership = Ownership.find(id)
      ownership.update_attribute(:position, index) if ownership
    end
    render nothing: true
  end

  private

    def ownership_params
      params.require(:ownership).permit(:email_address, :contactable, :phone, :created_by)
    end

end
