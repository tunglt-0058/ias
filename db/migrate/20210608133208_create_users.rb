class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :avatar
      t.string :email, null: false
      t.string :password
      t.integer :account_type, default: 0, null: false
      t.string :display_id

      t.timestamps
    end
  end
end
