class CreateFollowExperts < ActiveRecord::Migration[5.2]
  def change
    create_table :follow_experts do |t|
      t.integer :user_id
      t.integer :expert_id

      t.timestamps
    end
  end
end
