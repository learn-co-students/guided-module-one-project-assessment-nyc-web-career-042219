def welcome
  puts "You entered a dark room..."
  puts "A bearded wizard appears"
  puts "Bearded Wizard: What the heck? Who are you? Why are you in my special place?"
  puts "Enter your name:"
  name = gets.chomp #needs to be saved
  User.find_or_create_by(name: name)

  puts "Bearded Wizard: So... for some reason you have entered the Superhero Fighting Arena"
  puts "Bearded Wizard: CHOOSE YOUR SUPERHERO AND FIGHT TO THE DEATH or to the end of the stages."
end

def confirm(hero_hash)
  puts "Superhero stats - HP: #{hero_hash['powerstats']['durability']}"
  puts " ATK: #{hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']}"
  puts " DEF: #{hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']}"
  puts " SPEED: #{hero_hash['powerstats']['speed']}"
  puts "Bearded Wizard: Oh interesting... are you sure you want to pick this superhero?"
  puts "Type (Y) to confirm or (N) to go back and choose another superhero."

  input = gets.chomp.lowercase

end

def chose_a_hero
stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
  stats_array = JSON.parse(stats_string)
  sample = stats_array.sample(5)
  i = nil
  while i == nil
    puts "Please pick one of the following:\n"
    puts "1.#{sample[0]["name"]} \n2.#{sample[1]["name"]} \n3.#{sample[2]["name"]} \n4.#{sample[3]["name"]} \n5.#{sample[4]["name"]}"
    num = gets.chomp
    num = num.to_i
    if num < 1 || num > 5
      puts "Please enter a valid #"
    else
      i = sample[num-1]
      # put confirm here
      confirm(i)
    end
  end
end

def stage

end
