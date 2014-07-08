class CreateBusinesses < ActiveRecord::Migration
  def change
    create_table :businesses do |t|
      t.string :name
      t.string :country
      t.string :postalcode
      t.string :region
      t.string :city
      t.string :street
      t.string :phone
      t.string :alt_phone
      t.string :email
      t.string :description
      t.string :logo
      t.string :image_1
      t.string :image_2
      t.boolean :hidden, default: false
      t.integer :created_by

      t.timestamps
    end
    add_index :businesses, [:country, :city, :name]
  end
end
