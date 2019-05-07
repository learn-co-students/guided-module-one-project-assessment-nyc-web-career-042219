class Cli < ActiveRecord::Base

  def welcome
    puts 'Welcome to Ticket Pick, please enter your username:'
    username = gets.chomp
    user = User.find_or_create_by(name: username)
  end

end
