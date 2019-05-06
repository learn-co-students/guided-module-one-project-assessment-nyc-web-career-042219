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

class Usergame < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
end
