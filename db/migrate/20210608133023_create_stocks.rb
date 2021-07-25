class CreateStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :stocks do |t|
      t.integer :sector_id, null: false
      t.integer :industry_id, null: false
      t.string :code, null: false, length: {maximum: 16}
      t.string :company_name, null: false, length: {maximum: 256}
      t.string :exchange_name, null: false, length: {maximum: 16}
      t.integer :current_price, null: false
      t.integer :lowest_forecast_price
      t.integer :average_forecast_price
      t.integer :highest_forecast_price
      t.string :display_id, null: false, length: {maximum: 16}

      t.timestamps
    end
  end
end
