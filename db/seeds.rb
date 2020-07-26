
gavin = User.find_or_create_by(name: "Gavin O\'Connor", location: "Brooklyn, NY", age: 36, gender: "male", relationship_status: "engaged")
julie = User.find_or_create_by(name: "Julie Zeltser", location: "Brooklyn, NY", age: 34, gender: "female", relationship_status: "engaged")
brian = User.find_or_create_by(name: "Brian Ponto", location: "Brooklyn, NY", age: 36, gender: "male", relationship_status: "married")
emily = User.find_or_create_by(name: "Emily Holland", location: "New York, NY", age: 36, gender: "female", relationship_status: "single")
joe = User.find_or_create_by(name: "Joe Pants", location: "New York, NY", age: 45, gender: "male", relationship_status: "single")
ferris = User.find_or_create_by(name: "Ferris Caldwell", location: "New York, NY", age: 26, gender: "female", relationship_status: "single")
chris = User.find_or_create_by(name: "Chris Something", location: "Washington, DC", age: 25, gender: "male", relationship_status: "single")
jane = User.find_or_create_by(name: "Jane Doe", location: "Washington, DC", age: 27, gender: "female", relationship_status: "single")
kate = User.find_or_create_by(name: "Kate Murrin", location: "New York, NY", age: 31, gender: "female", relationship_status: "single")
jeff = User.find_or_create_by(name: "Jeff Bobula", location: "Brooklyn, NY", age: 26, gender: "male", relationship_status: "single")


vitus = Venue.find_or_create_by(name:"St. Vitus", location: "Brooklyn, NY", family_friendly: false)
mercury = Venue.find_or_create_by(name:"Mercury Lounge", location: "New York, NY", family_friendly: true)
black_cat = Venue.find_or_create_by(name:"Black Cat", location: "Washington, DC", family_friendly: false)
elsewhere = Venue.find_or_create_by(name:"Elsewhere", location: "Brooklyn, NY", family_friendly: false)
rr_hotel = Venue.find_or_create_by(name:"Rock & Roll Hotel", location: "Washington, DC", family_friendly: true)
bowery = Venue.find_or_create_by(name:"Bowery Ballroom", location: "New York, NY", family_friendly: false)

mats = Ticket.find_or_create_by(user_id: User.all.sample.id, venue_id: Venue.all.sample.id, band_name: "The Replacements")
descendants = Ticket.find_or_create_by(user_id: User.all.sample.id, venue_id: Venue.all.sample.id, band_name: "The Descendants")
skeletonwitch = Ticket.find_or_create_by(user_id: User.all.sample.id, venue_id: Venue.all.sample.id, band_name: "Skeletonwitch")
samiam = Ticket.find_or_create_by(user_id: User.all.sample.id, venue_id: Venue.all.sample.id, band_name: "Samiam")
weapons = Ticket.find_or_create_by(user_id: User.all.sample.id, venue_id: Venue.all.sample.id, band_name: "Primitive Weapons")

