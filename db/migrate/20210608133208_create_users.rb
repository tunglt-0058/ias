class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name, null: false, length: {maximum: 64}
      t.string :avatar, length: {maximum: 256}
      t.string :email, null: false, length: {maximum: 64}
      t.integer :account_type, default: 0, null: false
      t.string :display_id, null: false, length: {maximum: 256}

      t.timestamps
    end
  end
end
