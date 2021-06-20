class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, length: {maximum: 100}
      t.string :description, length: {maximum: 512}
      t.string :avatar, length: {maximum: 200}
      t.string :display_id, null: false, length: {maximum: 200}

      t.timestamps
    end
  end
end
