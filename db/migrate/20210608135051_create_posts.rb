class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :expert_id, null: false
      t.integer :stock_id, null: false
      t.integer :position, null: false
      t.integer :target_price, null: false
      t.text :content, null: false
      t.string :display_id

      t.timestamps
    end
  end
end
