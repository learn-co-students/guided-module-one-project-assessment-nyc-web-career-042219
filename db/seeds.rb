require 'faker'
#* players
# == Schema Information
#
# Table name: users
#
#  id             :integer          not null, primary key
#  username       :string           not null
#  total_correct  :integer          default(0)
#  correct_streak :integer          default(0)
#  num_games      :integer          default(0)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
p1 = User.find_or_create_by(username: 'player 1')
p2 = User.find_or_create_by(username: 'player 2')
p3 = User.find_or_create_by(username: 'player 3')
p4 = User.find_or_create_by(username: 'player 4')

#* games
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
g1 = Game.find_or_create_by(num_players: 1, lead_player: '')
g2 = Game.find_or_create_by(num_players: 2, lead_player: '')
g3 = Game.find_or_create_by(num_players: 3, lead_player: '')
g4 = Game.find_or_create_by(num_players: 4, lead_player: '')

#* usergames
# == Schema Information
#
# Table name: usergames
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  game_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
ug1_1 = Usergame.find_or_create_by(user_id: p1.id, game_id: g1.id)

ug2_1 = Usergame.find_or_create_by(user_id: p1.id, game_id: g2.id)
ug2_2 = Usergame.find_or_create_by(user_id: p2.id, game_id: g2.id)

ug3_1 = Usergame.find_or_create_by(user_id: p1.id, game_id: g3.id)
ug3_2 = Usergame.find_or_create_by(user_id: p2.id, game_id: g3.id)
ug3_3 = Usergame.find_or_create_by(user_id: p3.id, game_id: g3.id)

ug4_1 = Usergame.find_or_create_by(user_id: p1.id, game_id: g4.id)
ug4_2 = Usergame.find_or_create_by(user_id: p2.id, game_id: g4.id)
ug4_3 = Usergame.find_or_create_by(user_id: p3.id, game_id: g4.id)
ug4_4 = Usergame.find_or_create_by(user_id: p4.id, game_id: g4.id)