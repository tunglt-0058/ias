class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name, null: false, length: {maximum: 128}
      t.string :description, length: {maximum: 512}
      t.string :avatar, length: {maximum: 256}
      t.string :display_id, null: false, length: {maximum: 256}

      t.timestamps
    end
  end
end
