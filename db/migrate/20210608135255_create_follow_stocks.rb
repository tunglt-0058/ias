class CreateFollowStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_stocks do |t|
      t.integer :user_id, null: false
      t.integer :stock_id, null: false

      t.timestamps
    end
  end
end
