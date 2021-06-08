class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :category_id
      t.string :code
      t.string :company_name
      t.string :exchange_name
      t.integer :current_price
      t.json :price_past
      t.integer :price_forecast_low
      t.integer :price_forecast_average
      t.integer :price_forecast_high

      t.timestamps
    end
  end
end
