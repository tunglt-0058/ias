class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :category_id, null: false
      t.string :code, null: false, length: {maximum: 20}
      t.string :company_name, null: false, length: {maximum: 255}
      t.string :exchange_name, null: false, length: {maximum: 100}
      t.integer :current_price, null: false
      t.integer :price_forecast_low
      t.integer :price_forecast_average
      t.integer :price_forecast_high
      t.string :display_id, null: false, length: {maximum: 200}

      t.timestamps
    end
  end
end
