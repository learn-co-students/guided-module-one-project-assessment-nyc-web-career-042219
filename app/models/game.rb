# == Schema Information
#
# Table name: games
#
#  id          :integer          not null, primary key
#  num_players :integer
#  lead_player :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Game < ActiveRecord::Base
  has_many :usergames
  has_many :users, through: :usergames
end
