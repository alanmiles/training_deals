class AddIndexToProducts < ActiveRecord::Migration
  def change
  	add_index :products, :price_in_dollars
  end
end
