class AddIndexToBusinessesGeolocation < ActiveRecord::Migration
  def change
  	add_index :businesses, [:latitude, :longitude]
  end
end
