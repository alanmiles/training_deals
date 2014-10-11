class CreateVisitors < ActiveRecord::Migration
  def change
    create_table :visitors do |t|
      t.string :ip_address
      t.float :latitude
      t.float :longitude
      t.string :city
      t.string :country

      t.timestamps
    end

    add_index :visitors, :ip_address
  end
end
