require_relative '../config/environment'

ActiveRecord::Base.logger = nil

game = CLI.new()
game.title_screen
