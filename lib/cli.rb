require 'rest-client'
require 'pry'
require 'json'

class CommandLineInterface

# Greeting the User, ask to post a ticket or search for tickets.

  def greet
    puts "Welcome to Ticket Pick!"
    puts "*" * 23
    puts "-- Post a Ticket or Search for what's available?"
    user_response
  end

# User response, depending on selection apply Search or Post helper functions.

  def user_response
    post_or_search = gets.chomp
    if post_or_search.downcase == "search"
      self.search_response
    end
    #if post, do some code
  end


# Search responses, user can select by venue, user, or city.

  def search_response
    puts "-- Search by Venue or User:" #or city
    venue_or_user = gets.chomp
      if venue_or_user.downcase == "venue"
        self.search_venue
      elsif venue_or_user.downcase == "user"
        self.search_user
      else
        self.greet
      end
  end

# Venue search helper function:
  def search_venue
    puts "-- Enter Venue Name:"
    venue_input = gets.chomp
    venue_input = Venue.find_by(name: venue_input)
      if venue_input
          band_info = venue_input.tickets.first.band_name
          puts "-- Looks like we have a ticket for #{band_info} at #{venue_input.name}!"
          puts "*"*60
          puts "-- Would you like to view the ticketholder? Y/N"
          view_ticketholder = gets.chomp
            if view_ticketholder.downcase == "y"
              user_id = venue_input.tickets.first.user_id
            puts "#{User.find(user_id).name} has an extra ticket. We're working to let you message them soon!"
            puts " "
            else
              self.greet
            end
      end
  end

# User search function, can choose between input and list of all users.
  def search_user
    puts "-- Enter User Name, or enter 'all' for a current list of ticketholders."
    name_input = gets.chomp
      if name_input.downcase == "all"
        self.user_by_number
      elsif
        name_input = User.all.find_by(name: name_input)
        self.user_by_name(name_input)
      else
        self.greet
      end
    end

# Name search helper function.
    def user_by_name(name_input)
      name_info = name_input.tickets.first.user_id
      name_with_band = name_input.tickets.first.band_name
      puts "-- Looks like #{User.find(name_info).name} has a ticket for #{name_with_band}."
      puts "*"*60
      puts "-- Would you like to message #{User.find(name_info).name}? Y/N"
      response = gets.chomp
        if
          response.downcase == "y"
          puts "-- We're working to let you message them soon!"
          puts " "
          self.greet
        else
          self.greet
    end
  end

# List names helper function
    def user_by_number
      all_names = User.all.find_each.with_index do |person, index|
         puts "#{index + 1}. #{person.name}"
         all_names
        end
          puts "/n" + "*" * 23 + "/n"
          puts "-- Enter a User's number for more info:"
          num_select = gets.chomp.to_i
            if num_select == User.all.find_by(id: num_select).id
              ticket_info = User.all.find_by(id: num_select).tickets.first.band_name
              user_name = User.all.find_by(id: num_select).name
              puts "#{user_name} has the following tickets: #{ticket_info}"
            else
              puts "It looks like that user doesn't have any current tickets."
            end
    end



    # def search_city
    # end


end



    #list of venues - should return a list of venues, with the band_names
    #list of users - should return users who have tickets, with band_names

    #list of tickets

  #   response = RestClient.get("https://api.songkick.com/api/3.0/artists/379603/gigography.json?apikey=nu80rqJInvFVVDU4")
  #   string = response.body
  #   data = JSON.parse(string)
  #   binding.pry
  # end
