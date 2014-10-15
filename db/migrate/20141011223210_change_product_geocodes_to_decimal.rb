class ChangeProductGeocodesToDecimal < ActiveRecord::Migration
  def up
    change_column :businesses, :latitude, :decimal, :precision => 9, :scale => 6, null: false
    change_column :businesses, :longitude, :decimal, :precision => 9, :scale => 6, null: false
  end

  def down
    change_column :businesses, :latitude, :float
    change_column :businesses, :longitude, :float
  end
end
