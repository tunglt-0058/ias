class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.integer :expert_id
      t.integer :stock_id
      t.integer :position
      t.integer :target_price
      t.integer :ratings
      t.text :content

      t.timestamps
    end
  end
end
