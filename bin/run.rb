require_relative '../config/environment'
require 'pry'
ActiveRecord::Base.logger = false

my_CLI = CLI.new
my_CLI.welcome
new_tourist = my_CLI.tourist_name
new_trip_name = my_CLI.trip_name
new_country = my_CLI.country
my_CLI.create_trip(new_tourist, new_trip_name, new_country)
