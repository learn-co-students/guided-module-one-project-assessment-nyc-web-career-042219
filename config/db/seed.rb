require 'pry'
require 'rest-client'
# class RequestClient
  # def self.get_rest_data
   # binding.pry
   response = RestClient.get("http://www.omdbapi.com/?s=#{user_input}&apikey=a2d3299b")
   binding.pry
   JSON.parse(response)
  # end

# end
