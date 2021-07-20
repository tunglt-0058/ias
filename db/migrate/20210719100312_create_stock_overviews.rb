class CreateStockOverviews < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_overviews do |t|
      t.integer :stock_id, null: false
      t.string :revenue
      t.string :year_range
      t.float :eps
      t.integer :volume
      t.string :market_cap
      t.string :dividend_yield
      t.float :average_vol_3m
      t.float :pe_ratio
      t.float :beta
      t.float :year_change
      t.integer :shares_outstanding
      t.datetime :next_earnings_date

      t.timestamps
    end
  end
end
