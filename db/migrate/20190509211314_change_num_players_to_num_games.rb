class ChangeNumPlayersToNumGames < ActiveRecord::Migration[5.2]
  def change
    rename_column :games, :num_players, :num_games
  end
end
