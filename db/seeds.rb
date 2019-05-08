10.times do
  User.create(
    name: Faker::Name.unique.name,
    location: Faker::Address.city,
    age: rand(21..45),
    gender: Faker::Gender.binary_type,
    relationship_status: Faker::Boolean.boolean
  )
end

10.times do
  Venue.create(
    name: Faker::Restaurant.name,
    location: Faker::Address.city,
    family_friendly: Faker::Boolean.boolean
  )
end

10.times do
  Ticket.create(
    user_id: User.all.sample.id,
    venue_id: Venue.all.sample.id
  )
end
