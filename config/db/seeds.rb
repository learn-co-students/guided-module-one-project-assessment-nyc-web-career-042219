require 'pry'
require 'rest-client'
# class RequestClient
  # def self.get_rest_data
   # binding.pry

puts "Welcome"

# puts "please enter your username"
input = gets.chomp.downcase


   response = RestClient.get("http://www.omdbapi.com/?s=#{input}&?y=1973&apikey=a2d3299b")
   data_hash = JSON.parse(response)
   binding.pry

   # def self.get_user_input
   #   user_input = gets.chomp.downcase
   #
   #   response = RestClient.get("http://www.omdbapi.com/?s=#{user_input}&apikey=a2d3299b")
   #
   #   return_data = JSON.parse(response)
   #
   #   puts return_dataf
   # end


  # end

# end
