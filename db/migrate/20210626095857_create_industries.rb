class CreateIndustries < ActiveRecord::Migration[6.1]
  def change
    create_table :industries do |t|
      t.string :name, null: false, length: {maximum: 50}
      t.string :avatar, length: {maximum: 200}
      t.string :display_id, null: false, length: {maximum: 50}

      t.timestamps
    end
  end
end
