class CreateCategories < ActiveRecord::Migration[5.2]
  def change
    create_table :categories do |t|
      t.string :name, null: false, length: {maximum: 50}
      t.string :avatar, length: {maximum: 200}
      t.string :display_id, null: false, length: {maximum: 200}

      t.timestamps
    end
  end
end
