class CreateExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :experts do |t|
      t.integer :user_id, null: false
      t.string :company_name
      t.string :sector
      t.integer :rank
      t.float :system_rate
      t.float :success_rate
      t.float :average_return
      t.string :display_id

      t.timestamps
    end
  end
end
