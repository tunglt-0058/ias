class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :sector_id, null: false
      t.integer :industry_id, null: false
      t.string :code, null: false, length: {maximum: 10}
      t.string :company_name, null: false, length: {maximum: 255}
      t.string :exchange_name, null: false, length: {maximum: 10}
      t.integer :current_price, null: false
      t.integer :price_forecast_low
      t.integer :price_forecast_average
      t.integer :price_forecast_high
      t.string :display_id, null: false, length: {maximum: 10}

      t.timestamps
    end
  end
end
