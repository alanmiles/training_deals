class CreateEvents < ActiveRecord::Migration 
  def change
    create_table :events do |t|
      t.integer :product_id
      t.date :start_date
      t.date :end_date
      t.decimal :price, precision: 8, scale: 2
      t.time :start_time
      t.time :finish_time
      t.string :attendance_days
      t.string :time_of_day
      t.string :location
      t.string :note
      t.integer :created_by
      t.boolean :cancelled, default: false   #use cancelled instead of deletion when
                                   #event already has user interest.

      t.timestamps
    end
    add_index :events, [:product_id, :start_date], unique: true
  end
end
