require 'rest-client'
require 'pry'
require 'json'


  def greet
    puts 'Welcome to Ticket Pick!'
    puts 'Would you like to Share or Search for a ticket?'
    user_input = gets.chomp
    if user_input.downcase == "search"
      puts "Choose by venue or user:"
      first_input = gets.chomp
      if first_input.downcase == "venue"
        puts "Choose by Name:"
        venue_input = gets.chomp
        venue_input = Venue.all.find_by(name: venue_input)

      end
      #list of users
      user_input = gets.chomp


    elsif user_input.downcase == "share"
      puts

    end

    #list of venues
    #list of users

    # user = User.find_or_create_by(name: username)

    response = RestClient.get("https://api.songkick.com/api/3.0/artists/379603/gigography.json?apikey=nu80rqJInvFVVDU4")
    string = response.body
    data = JSON.parse(string)
    binding.pry
  end











# books.each do |book|
#   title = book["volumeInfo"]["title"]
#   author_data = book["volumeInfo"]["authors"]
#   if author_data
#     authors = author_data.join(" & ")
#   else
#     authors = "No Authors found for this book"
#   end
#
#   description_data = book["volumeInfo"]["description"]
#
#   if description_data
#     description = description_data[0..100] + "..."
#   else
#     description = "No description found for this book"
#   end
#
#   puts "Title: #{title}"
#   puts "Authors: #{authors}"
#   puts "Description: #{description}"
#
#   # puts author names separated by an &
#
#   # puts the first 100 characters of the description followed by ...
#
#   puts "*" * 15
# end
