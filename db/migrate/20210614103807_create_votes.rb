class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :stock_id, null: false
      t.integer :user_id, null: false
      t.integer :vote, null: false

      t.timestamps
    end
  end
end
