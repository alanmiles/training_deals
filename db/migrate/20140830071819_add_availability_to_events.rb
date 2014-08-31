class AddAvailabilityToEvents < ActiveRecord::Migration
  def change
    add_column :events, :places_available, :integer, default: 0
    add_column :events, :places_sold, :integer, default: 0
  end
end
