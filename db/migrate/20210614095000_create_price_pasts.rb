class CreatePricePasts < ActiveRecord::Migration[5.2]
  def change
    create_table :price_pasts do |t|
      t.integer :stock_id, null: false
      t.datetime :month, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
