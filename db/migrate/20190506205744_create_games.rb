class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.integer :num_players
      t.string :lead_player
      t.timestamps
    end
  end
end
