class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :description
      t.text :street_address
      t.string :city
      t.string :state
      t.string :postal_code
      t.string :country
      t.float :latitude
      t.float :longitude
      t.boolean :hide_address, default: false
      t.string :phone
      t.string :alt_phone
      t.string :email
      t.string :website
      t.string :logo
      t.string :image_1
      t.string :image_2
      t.boolean :inactive, default: false
      t.datetime :inactive_from
      t.integer :created_by

      t.timestamps
    end
    add_index :businesses, [:country, :city, :name], unique: true
  end
end
