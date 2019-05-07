require 'Pry'
require_relative '../config/environment'

def greeting
  puts "Welcome to Adam, Jake, and Oscar's movie selector! Please select a genre you'd like to to search for:"
end

def get_user_input
  user_input = gets.chomp
end

greeting
get_user_input
binding.pry
