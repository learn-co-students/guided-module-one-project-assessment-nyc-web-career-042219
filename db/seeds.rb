20 times do
  User.create(
    name: Faker::Name.unique.name,
    location: Faker::Address.unique.city,
    age: Faker::Age.unique.age,
    gender: Faker::Gender.unique.gender,
    relationship_status:
    )
end
