class CreateFollowStocks < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_stocks do |t|
      t.integer :user_id
      t.integer :stock_id

      t.timestamps
    end
  end
end
