class AddDefaultValueToNumGames < ActiveRecord::Migration[5.2]
  def change
    change_column :games, :num_games, :integer, :default => 0
  end
end
