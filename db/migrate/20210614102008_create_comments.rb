class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.integer :post_id, null: false
      t.integer :user_id, null: false
      t.string :content, null: false, length: {maximum: 255}
      t.integer :parent_id
      t.integer :reply_id

      t.timestamps
    end
  end
end
