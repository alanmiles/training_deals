class CreateOwnerships < ActiveRecord::Migration
  def change
    create_table :ownerships do |t|
      t.integer :business_id
      t.integer :user_id
      t.string :email_address     #used on create to verify user exists in db and to establish user.id
      t.boolean :contactable, default: false
      t.string :phone
      t.integer :position
      t.integer :created_by

      t.timestamps
    end
    add_index :ownerships, [:business_id, :user_id], unique: true
  end
end
