class CLI
# require 'pry'

attr_accessor :tourist_name, :country, :trip_name

def welcome
  puts "Welcome to Travel Log!"
end

def tourist_name
  puts "To set up or access your account, please enter your first name."
  response = gets.chomp
  @tourist_name = Tourist.find_or_create_by(tourist_name: response)
end

def trip_name
  puts "What's the occasion for your vacation? (e.g. Birthday Trip 2019, Anniversary 2019, Bob's Bachelor Party)"
  response = gets.chomp
  @trip_name = Trip.find_or_create_by(trip_name: response)
end

def country
  puts "Where are you traveling? (enter country)"
  response = gets.chomp
  @country = Country.find_or_create_by(country_name: response)
end

def create_trip(tourist, trip_name, country)
    Trip.create(tourist_id: @tourist_name.id, trip_name: @trip_name.trip_name, country_id: @country.id)
    menu
end

def menu
    puts "What would you like to see?"
    puts "1. See all of my trips"
    puts "2. See all of my countries"
    puts "3. Delete a trip"
    puts "4. Update a trip name"
    puts "5. End program"
    puts "6. See trips by country"
    response = gets.chomp
    if response == '1'
      tourists_trips
      menu
    elsif response == '2'
      tourists_countries
      menu
    elsif response == '3'
      delete_trip
      menu
    elsif response == '4'
      update_trip_name
      menu
    elsif response == '5'
      puts "Goodbye!"
    elsif response =='6'
      new_method
      menu
    else
      puts "Not a valid response, please select again"
      menu
    end
end

def tourists_trips
    trips = Trip.where(tourist_id: @tourist_name.id).pluck(:trip_name)
    trips.each {|trip,num| puts trip}
end

def tourists_countries
    trips = @tourist_name.trips.all
    trips.each_with_index {|trip,num| puts "#{num+1}. " + trip.country.country_name}
end

def delete_trip
  puts "Here are your trips:"
  tourists_trips
  puts "What trip would you like to delete?"
  response = gets.chomp
  select_row_from_table = Trip.where(trip_name: response, tourist_id: @tourist_name.id)
  id_from_row = select_row_from_table.pluck(:id)
  Trip.destroy(id_from_row)
  puts "Success!  #{response} has been deleted"
end

def update_trip_name
  puts "Here are your trips:"
  tourists_trips
  puts "Which trip would you like to update?"
  response = gets.chomp
  puts "What is the new name for this trip?"
  new_trip_name = gets.chomp
  select_row_from_table = Trip.find_by(trip_name: response, tourist_id: @tourist_name.id)
  select_row_from_table.update(trip_name: new_trip_name)
  puts "Success! #{response} has been updated to #{new_trip_name}"
end

def new_method
  puts "Enter country"
  response = gets.chomp
  country = Country.find_by(country_name: response)
  trips = Trip.all.where(tourist_id: @tourist_name.id, country_id: country.id)
  trips.each {|trip| puts trip.trip_name}
end

end
