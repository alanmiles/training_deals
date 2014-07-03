class CreateGenres < ActiveRecord::Migration
  def change
    create_table :genres do |t|
      t.string :description
      t.integer :position
      t.integer :created_by, default: 1
      t.integer :status, default: 2				# 1 = approved, 2 = not yet approved, 3 = rejected

      t.timestamps
    end

    add_index :genres, :description
  end
end
