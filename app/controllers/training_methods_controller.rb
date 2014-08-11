class TrainingMethodsController < ApplicationController
  
  before_action :not_admin

  def index
  	@methods = TrainingMethod.order('position') 
  end

  def new
    @method = TrainingMethod.new
  end

  def create
    @method = TrainingMethod.new(training_method_params)
    if @method.save
      flash[:success] = "'#{@method.description}' added"
      redirect_to training_methods_path
    else
      render 'new'
    end
  end

  def edit
    @method = TrainingMethod.find(params[:id])
  end

  def update
    @method = TrainingMethod.find(params[:id])
    if @method.update_attributes(training_method_params)
      flash[:success] = "Updated to '#{@method.description}'"
      redirect_to training_methods_path
    else
      render 'edit'
    end
  end

  def destroy
    @method = TrainingMethod.find(params[:id]).destroy
    flash[:success] = "'#{@method.description}' deleted"
    redirect_to training_methods_path
  end

  def sort
    params[:training_method].each_with_index do |id, index|
      training_method = TrainingMethod.find(id)
      training_method.update_attribute(:position, index) if training_method
    end
    render nothing: true
  end

  private

		def training_method_params
			params.require(:training_method).permit(:description, :event)
		end

end
