class CreateDurations < ActiveRecord::Migration
  def change
    create_table :durations do |t|
      t.string :time_unit

      t.timestamps
    end

    add_index :durations, :time_unit, unique: true
  end
end
