class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :ip_address
      t.decimal :latitude, precision: 9, scale: 6
      t.decimal :longitude, precision: 9, scale: 6
      t.string :country

      t.timestamps
    end

    add_index :visitors, :ip_address
  end
end
