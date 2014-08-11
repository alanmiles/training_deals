class AddEventToTrainingMethods < ActiveRecord::Migration
  def change
    add_column :training_methods, :event, :boolean, default: false
  end
end
