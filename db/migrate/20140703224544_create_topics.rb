class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :description
      t.integer :category_id
      t.integer :created_by, default: 1
      t.integer :status, default: 2

      t.timestamps
    end

    add_index :topics, :category_id
    add_index :topics, [:category_id, :description], unique: true
  end
end
