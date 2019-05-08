class CLI
  def title_screen
    loop do
      puts "Welcome to Super Heroes Arena"
      puts "1.New Game \n2.Continue \n3.Exit"
      input = gets.chomp.to_i

      case input
      when 1
        start; break
      when 2
        puts "Please enter your name:"
        name = gets.chomp
        user = User.find_by(name: name)
        start_stage(user)
        break
      when 3
        puts "See you later sucka"; exit
      else
        puts "Please provide valid #"
      end
    end
  end

  def start
    puts "You entered a dark room..."
    puts "A bearded wizard appears"
    puts "Bearded Wizard: What the heck? Who are you? Why are you in my special place?"
    puts "Enter your name:"

    name = gets.chomp
    user = User.find_or_create_by(name: name)

    choose_a_hero(user)
  end

  def choose_a_hero(user)
    puts "\nBearded Wizard: So... for some reason you have entered the Superhero Fighting Arena"
    puts "Bearded Wizard: CHOOSE YOUR SUPERHERO AND FIGHT TO THE DEATH or to the end of the stages."
    puts "Bearded Wizard: You'll be given a choice between 5 random superheroes."

    sample_heroes = get_data.sample(5)

    loop do
      puts "Please pick one of the following:"
      puts "1.#{sample_heroes[0]["name"]} \n2.#{sample_heroes[1]["name"]} \n3.#{sample_heroes[2]["name"]} \n4.#{sample_heroes[3]["name"]} \n5.#{sample_heroes[4]["name"]}"
      input = gets.chomp.to_i
      if input < 1 || input > 5
        puts "Please enter a valid #"
      else
        confirm(sample_heroes[input - 1], user)
        break
      end
    end
  end

  def confirm(hero_hash, user)
    hero_url = hero_hash['images']['md']
    download_image(hero_url)
    print_picture(hero_url.split('/').last)

    puts "#{hero_hash['name']} stats:\n"
    puts "HP: #{hero_hash['powerstats']['durability']}\n"
    puts "ATK: #{hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']}\n"
    puts "DEF: #{hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']}\n"
    puts "SPEED: #{hero_hash['powerstats']['speed']}\n\n"
    puts "Bearded Wizard: Oh interesting... are you sure you want to pick this superhero?"
    puts "Type (Y) to confirm or (N) to go back and choose another superhero."


    loop do
      input = gets.chomp.downcase
      case input
      when 'y'
        puts "Bearded Wizard: I guess that's a good choice..."
        #save user's superhero choice and stats
        user.save_stats(hero_hash)
        #call stage
        start_stage(user)
        break
      when 'n'
        #go back to choose_a_hero
        choose_a_hero(user)
        break
      else
        puts "Beard Wizard: QUIT MESSING AROUND! TYPE IN Y OR N!"
      end
    end
  end

  def start_stage(user)
    puts "Bearded Wizard: Well then, it's time to FIGHT TO THE DEATH!"

    count = user.stage_level
    until count == 5
      puts "\nSTAGE #{count} BEGIN!"
      puts "A challenger appears..."
      #create enemy and save to stage
      enemy = Enemy.new()
      enemy_hash = get_data.sample(1).first
      enemy.save_stats(enemy_hash)

      #print that you're fighting this enemy name
      enemy_url = enemy_hash['images']['md']
      download_image(enemy_url)
      print_picture(enemy_url.split('/').last)

      new_stage = Stage.find_or_create_by(user_id: user.id, enemy_id: enemy.id, level: count)
      result = new_stage.battle

      if result
        #loop for new stage but wait 2 seconds before starting
        sleep(2)
        count += 1
        user.update(stage_level: count)
        #if we're on stage 5 you won!
        if count == 5
          victory
          user.update(stage_level: 1)
          break
        end
      else
        user.update(stage_level: 1)
        game_over(user)
        break
      end
    end
  end

  def victory
    puts "Bearded Wizard: Woah! You actually won! That's incredible... congrats"
    print_picture("winner.jpg")

    play_again?
  end

  def game_over(user)
    puts "Bearded Wizard: Haha, I knew you'd lose."

    play_again?
  end

  def play_again?
    puts "Want to play again?"
    puts "Type (Y) to start over and try again or (N) to stop playing"

    loop do
      input = gets.chomp.downcase
      case input
      when 'y'
        choose_a_hero(user); break
      when 'n'
        break;
      end
    end
  end

  def print_picture(url)
    Catpix::print_image url, center_x: true, limit_y: 1
  end

  def download_image(url)
    open(url) do |u|
      File.open(url.split('/').last, 'wb') {|f| f.write(u.read)}
    end
  end

  def get_data
    stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
    stats_array = JSON.parse(stats_string)
    stats_array
  end
end
