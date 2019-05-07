class CreateStage < ActiveRecord::Migration[5.2]
  def change
    create_table :stages do |t|
      t.integer :user_id
      t.integer :enemy_id
      t.integer :level
    end
  end
end
