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

class User < ActiveRecord::Base
  has_many :usergames
  has_many :games, through: :usergames
end
