class CreatePricePasts < ActiveRecord::Migration[5.2]
  def change
    create_table :price_pasts do |t|
      t.integer :stock_id, null: false
      t.datetime :time, null: false
      t.integer :price, null: false, default: 0

      t.timestamps
    end
  end
end
