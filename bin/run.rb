require_relative '../config/environment'


puts "hello world"

welcome
chose_a_hero
confirm

user = User.new
enemy = Enemy.new
stage = Stage.new(user: user, enemy: enemy)

stage.user_stats
