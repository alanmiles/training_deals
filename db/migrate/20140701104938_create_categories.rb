class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :description
      t.integer :genre_id
      t.integer :created_by, default: 1
      t.integer :status, default: 2     # 1 = approved, 2 = not yet approved, 3 = rejected

      t.timestamps
    end
    add_index :categories, :genre_id
    add_index :categories, [:genre_id, :description], unique: true
  end
end
