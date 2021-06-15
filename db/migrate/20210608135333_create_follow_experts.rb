class CreateFollowExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_experts do |t|
      t.integer :user_id, null: false
      t.integer :expert_id, null: false

      t.timestamps
    end
  end
end
