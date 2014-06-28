class CreateContentLengths < ActiveRecord::Migration
  def change
    create_table :content_lengths do |t|
      t.string :description
      t.integer :position

      t.timestamps
    end

    add_index :content_lengths, :description
  end
end
