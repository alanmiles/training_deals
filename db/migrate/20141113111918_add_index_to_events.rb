class AddIndexToEvents < ActiveRecord::Migration
  def change
  	add_index :events, :price_in_dollars
  end
end
