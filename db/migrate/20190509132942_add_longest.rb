class AddLongest < ActiveRecord::Migration[5.2]
  def change
      add_column :users, :longest_streak, :integer, default: 0
    end
  end
