class DropColumnsFromGame < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :lead_player
  end
end
