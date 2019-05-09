# require 'faker'
# Country.destroy_all
# Tourist.destroy_all
# Trip.destroy_all
#
# 50.times {Tourist.create( name:Faker::Name.unique.name)}
#
# 50.times {Country.create(name:Faker::Country.name)}

harry = Tourist.create(tourist_name: "Harry")
megan = Tourist.create(tourist_name: "Megan")
archie = Tourist.create(tourist_name: "Archie")

guam = Country.create(country_name: "Guam")
france = Country.create(country_name: "France")
paris = Country.create(country_name: "Paris")

Trip.create(trip_name: "Bachelorette June 2019", tourist_id: megan.id, country_id: france.id)
Trip.create(trip_name: "Christmas 2017", tourist_id: megan.id, country_id: guam.id)
Trip.create(trip_name: "Christmas 2017", tourist_id: harry.id, country_id: guam.id)
