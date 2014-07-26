class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :business_id
      t.string :title
      t.string :ref_code
      t.integer :topic_id
      t.string :qualification
      t.integer :training_method_id
      t.integer :duration_id
      t.decimal :duration_number
      t.integer :content_length_id
      t.decimal :content_number
      t.string :currency
      t.decimal :standard_cost
      t.text :content
      t.text :outcome
      t.boolean :current, default: true
      t.string :image
      t.string :web_link
      t.integer :created_by

      t.timestamps
    end
    add_index :products, :business_id
    add_index :products, :topic_id
    add_index :products, [:business_id, :topic_id, :title], unique: true
  end
end
