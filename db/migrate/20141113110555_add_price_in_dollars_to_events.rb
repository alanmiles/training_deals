class AddPriceInDollarsToEvents < ActiveRecord::Migration
  def change
  	add_column :events, :price_in_dollars, :decimal, :precision => 8, :scale => 2
  end
end
