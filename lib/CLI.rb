def welcome
  puts "You entered a dark room..."
  puts "A bearded wizard appears"
  puts "Bearded Wizard: What the heck? Who are you? Why are you in my special place?"
  puts "Enter your name:"

  name = gets.chomp
  user = User.find_or_create_by(name: name)

  puts "Bearded Wizard: So... for some reason you have entered the Superhero Fighting Arena"
  puts "Bearded Wizard: CHOOSE YOUR SUPERHERO AND FIGHT TO THE DEATH or to the end of the stages."

  choose_a_hero(user)
end

def choose_a_hero(user)
  stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
  stats_array = JSON.parse(stats_string)
  sample_heroes = stats_array.sample(5)

  loop do
    puts "Please pick one of the following:\n"
    puts "1.#{sample_heroes[0]["name"]} \n2.#{sample_heroes[1]["name"]} \n3.#{sample_heroes[2]["name"]} \n4.#{sample_heroes[3]["name"]} \n5.#{sample_heroes[4]["name"]}"
    num = gets.chomp.to_i
    if num < 1 || num > 5
      puts "Please enter a valid #"
    else
      confirm(sample_heroes[num - 1], user)
      break
    end
  end
end

def confirm(hero_hash, user)
  puts "#{hero_hash['name']} stats:\n"
  puts "HP: #{hero_hash['powerstats']['durability']}\n"
  puts "ATK: #{hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']}\n"
  puts "DEF: #{hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']}\n"
  puts "SPEED: #{hero_hash['powerstats']['speed']}\n"
  puts "Bearded Wizard: Oh interesting... are you sure you want to pick this superhero?"
  puts "Type (Y) to confirm or (N) to go back and choose another superhero."

  input = gets.chomp.downcase
  loop do
    if input == 'y'
      puts "Bearded Wizard: I guess that's a good choice..."
      #save user's superhero choice and stats
      user.save_stats(hero_hash)
      #call stage
      stage(user)
      break
    elsif input == 'n'
      #go back to choose_a_hero
      choose_a_hero(user)
      break
    else
      print "Beard Wizard: QUIT MESSING AROUND! TYPE IN Y OR N!"
    end
  end
end

def stage(user)
  print "Bearded Wizard: Well then, it's time to FIGHT TO THE DEATH!"
  print "STAGE BEGIN!"

  new_stage = Stage.new(user: user)
  won = new_stage.battle

  if won
    victory(user)
  else
    game_over(user)
  end
end

def victory(user)
  print "Bearded Wizard: Woah! You actually won! That's incredible... congrats"
  print "VICTORY!"

end

def game_over(user)
  print "Bearded Wizard: Heh, figured you lose, nice try"
  print "Want to try again?"
  print "Type (Y) to start over and try again or (N) to stop playing"

  input = gets.chomp.downcase
  loop do
    if input == 'y'
      choose_a_hero(user)
      break
    elsif input == 'n'
      break
    end
  end
end
