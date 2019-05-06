require_relative '../config/environment'

user = User.new
enemy = Enemy.new
stage = Stage.new(user: user, enemy: enemy)

stage.user_stats
