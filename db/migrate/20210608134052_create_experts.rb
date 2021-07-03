class CreateExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :experts do |t|
      t.integer :user_id, null: false
      t.string :company_name, null: false, length: {maximum: 256}
      t.string :sector, null: false, length: {maximum: 256}
      t.float :system_rate, null: false, default: 0
      t.float :success_rate, null: false, default: 0
      t.float :average_return, null: false, default: 0
      t.float :score, null: false, default: 0
      t.string :display_id, null: false, length: {maximum: 256}

      t.timestamps
    end
  end
end
