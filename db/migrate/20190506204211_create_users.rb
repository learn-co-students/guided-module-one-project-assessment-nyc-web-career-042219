class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username, null: false
      t.integer :total_correct, default: 0
      t.integer :correct_streak, default: 0
      t.integer :num_games, default: 0
      t.timestamps
    end
  end
end
