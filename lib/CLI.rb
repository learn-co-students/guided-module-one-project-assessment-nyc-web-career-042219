def start
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
  #test catpix
  show_picture(hero_hash)
  #put delay
  sleep(1)

  puts "#{hero_hash['name']} stats:\n"
  puts "HP: #{hero_hash['powerstats']['durability']}\n"
  puts "ATK: #{hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']}\n"
  puts "DEF: #{hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']}\n"
  puts "SPEED: #{hero_hash['powerstats']['speed']}\n\n"
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
      input = gets.chomp.downcase
    end
  end
end

def stage(user)
  puts "Bearded Wizard: Well then, it's time to FIGHT TO THE DEATH!"

  count = 1
  while count < 5
    puts "STAGE #{count} BEGIN!"
    new_stage = Stage.new(user_id: user.id, level: count)
    result = new_stage.battle

    if result
      #loop for new stage
      count += 1
    else
      game_over(user)
      break
    end
  end

  victory
end

def victory
  puts "Bearded Wizard: Woah! You actually won! That's incredible... congrats"
  puts "VICTORY!"

  Catpix::print_image "winner.jpg", center_x: true, limit_y: 1
end

def game_over(user)
  puts "Bearded Wizard: Haha, I knew you'd lose."
  puts "Want to try again?"
  puts "Type (Y) to start over and try again or (N) to stop playing"

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

def show_picture(hero_hash)
  hero_url = hero_hash['images']['lg']
  download_image(hero_url)

  Catpix::print_image hero_url.split('/').last, center_x: true, limit_y: 1
end

def download_image(url)
  open(url) do |u|
    File.open(url.split('/').last, 'wb') {|f| f.write(u.read)}
  end
end

def title_screen
  loop do
    puts "1.New Game \n2.Continue \n3.exit"
    user_input = gets.chomp.to_i
    if user_input == 1
      start
      break
    elsif user_input == 2
      puts "Please enter your name"
      user_name = gets.chomp
      user = User.find_by(name: "user_name")
      stage(user)
      break
    elsif user_input == 3
      puts "See you again"
      exit
    else
      puts "Please provide valid #"
    end
  end
end
