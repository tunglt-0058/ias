class CreateSectors < ActiveRecord::Migration[6.1]
  def change
    create_table :sectors do |t|
      t.string :name, null: false, length: {maximum: 64}
      t.string :avatar, length: {maximum: 256}
      t.string :display_id, null: false, length: {maximum: 256}

      t.timestamps
    end
  end
end
