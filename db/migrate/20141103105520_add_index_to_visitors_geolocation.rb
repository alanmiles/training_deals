class AddIndexToVisitorsGeolocation < ActiveRecord::Migration
  def change
  	add_index :visitors, [:latitude, :longitude]
  end
end
