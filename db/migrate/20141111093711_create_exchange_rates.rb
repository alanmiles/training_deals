class CreateExchangeRates < ActiveRecord::Migration
  def change
    create_table :exchange_rates do |t|
      t.string :currency_code
      t.decimal :rate, precision: 11, scale: 6

      t.timestamps
    end
    add_index :exchange_rates, :currency_code
  end
end
