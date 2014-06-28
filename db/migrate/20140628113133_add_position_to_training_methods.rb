class AddPositionToTrainingMethods < ActiveRecord::Migration
  def change
    add_column :training_methods, :position, :integer
  end
end
