class CreateStage < ActiveRecord::Migration[5.2]
  def change
    create_table :stage do |t|
      t.integer :user_id
      t.integer :enemy_id
    end
  end
end
