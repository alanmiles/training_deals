class ChangeUserGeocodesToDecimal < ActiveRecord::Migration
  def up
    change_column :users, :latitude, :decimal, :precision => 9, :scale => 6, null: false
    change_column :users, :longitude, :decimal, :precision => 9, :scale => 6, null: false
  end

  def down
    change_column :users, :latitude, :float
    change_column :users, :longitude, :float
  end
end
