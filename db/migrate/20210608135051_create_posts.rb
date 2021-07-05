class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :expert_id, null: false
      t.integer :stock_id, null: false
      t.integer :position, null: false
      t.integer :target_price, null: false
      t.datetime :target_time, null: false
      t.boolean :hit, null: false, default: false
      t.text :title, null: false, length: {maximum: 256}
      t.text :content, null: false, length: {maximum: 512}
      t.string :display_id, null: false, length: {maximum: 256}

      t.timestamps
    end
  end
end
