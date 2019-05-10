require_relative '../config/environment'

ActiveRecord::Base.logger = nil

system 'clear'

game = CLI.new()
game.title_screen
