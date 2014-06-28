class AddPositionToDurations < ActiveRecord::Migration
  def change
    add_column :durations, :position, :integer
  end
end
