class OwnershipsController < ApplicationController 
  
  before_action :not_signed_in,         only: [:index, :new, :edit]
  before_action :illegal_action,        only: [:create, :update, :destroy]
  before_action :team_member,           only: [:index, :new]
  before_action :team_member_edit,      only: :edit
  before_action :team_member_illegal,   only: :create
  before_action :team_member_wrong,     only: [:update, :destroy]
  
  def index
  	@business = Business.find(params[:my_business_id])
  	@ownerships = @business.ownerships.order("position")
  end

  def new
    @business = Business.find(params[:my_business_id])
    @ownership = @business.ownerships.new
    @ownership.created_by = current_user.id
  end

  def create
    @business = Business.find(params[:my_business_id])
    @ownership = @business.ownerships.build(ownership_params)
    @member = User.find_by(email: params[:ownership][:email_address])
    if @member.nil?
      flash.now[:error] = "Sorry, we can't find this person in the HROOMPH listings.  
          Please check that he/she has signed up to HROOMPH with this email address."
      render 'new'
    else 
      @ownership.user_id = @member.id
      if @ownership.save
        flash[:success] = "#{@ownership.user.name} added to the team."
        redirect_to my_business_ownerships_url(@business)
      else
        render 'new'
      end
    end
  end

  def edit
  	@ownership = Ownership.find(params[:id])
    @business = Business.find(@ownership.business_id)
  end

  def update
    @ownership = Ownership.find(params[:id])
    @business = Business.find(@ownership.business_id)
    if @ownership.update_attributes(ownership_params)
      flash[:success] = "#{@ownership.user.name} updated."
      redirect_to my_business_ownerships_path(@business)
    else
      render 'edit'
    end
  end

  def destroy
  	@ownership = Ownership.find(params[:id])
    @business = Business.find(@ownership.business_id)
    if @business.ownerships.count > 1
      @ownership.destroy
      flash[:success] = "Removed #{@ownership.user.name} from the team."
    else
      flash[:notice] = "Not removed! There has to be at least one team member."
    end
    redirect_to my_business_ownerships_path(@business)
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

    def not_signed_in
      unless signed_in?
        store_location
        flash[:notice] = "Page not accessible. Please sign in or sign up."
        redirect_to signin_url
      end
    end

    def illegal_action
      unless signed_in?
        flash[:notice] = "Action not permitted!"
        redirect_to(root_url)
      end
    end

    def team_member
      if signed_in?
        @business = Business.find(params[:my_business_id])
        team_member_valid(@business)
      end
    end

    def team_member_edit
      if signed_in?
        @ownership = Ownership.find(params[:id])
        @business = Business.find(@ownership.business_id)
        team_member_valid(@business)
      end
    end

    def team_member_illegal
      if signed_in?
        @business = Business.find(params[:my_business_id])
        illegal_team_member(@business)
      end
    end

    def team_member_wrong
      if signed_in?
        @ownership = Ownership.find(params[:id])
        @business = Business.find(@ownership.business_id)
        illegal_team_member(@business)
      end
    end


end
