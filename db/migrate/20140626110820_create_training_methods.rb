class CreateTrainingMethods < ActiveRecord::Migration
  def change
    create_table :training_methods do |t|
      t.string :description

      t.timestamps
    end

    add_index :training_methods, :description
  end
end
