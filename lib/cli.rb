require 'rest-client'
require 'pry'
require 'json'

class CommandLineInterface

  def greet
    puts ""
    puts "Welcome to Ticket Pick!"
    puts puts "*"*23
    puts "Post a Ticket or Search for what's out there?"
    user_response
  end

  def user_response
    post_or_search = gets.chomp
    if post_or_search.downcase == "search"
      self.search_response
    end
    #if post, do some code
  end

  def search_response
    puts "Choose by Venue or User:" #or city
    venue_or_user = gets.chomp
      if venue_or_user.downcase == "venue"
        self.search_venue
        #elsif self.search_user
        #elsif self.search_city
        #else exit method
      end
  end

    def search_venue
      puts "Choose by Venue Name:"
      venue_input = gets.chomp
      venue_input = Venue.all.find_by(name: venue_input)
        if venue_input
            band_info = venue_input.tickets.first.band_name
            puts "Looks like we have a ticket for #{band_info} at #{venue_input.name}!"
            puts "*"*60
            puts "Would you like to view the ticketholder? Y/N"
            view_ticketholder = gets.chomp
              if view_ticketholder.downcase == "y"
                user_id = venue_input.tickets.first.user_id
              puts "#{User.find(user_id).name}"
              else
                #exit method
              end
        end
    end



end



    #list of venues - should return a list of venues, with the band_names
    #list of users - should return users who have tickets, with band_names

    #list of tickets

  #   response = RestClient.get("https://api.songkick.com/api/3.0/artists/379603/gigography.json?apikey=nu80rqJInvFVVDU4")
  #   string = response.body
  #   data = JSON.parse(string)
  #   binding.pry
  # end
