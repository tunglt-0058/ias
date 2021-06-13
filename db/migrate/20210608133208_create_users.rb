class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :avatar
      t.string :email
      t.string :password
      t.integer :account_type, default: 0, null: false

      t.timestamps
    end
  end
end
