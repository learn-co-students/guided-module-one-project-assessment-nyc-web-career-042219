class Stage < ActiveRecord::Base
  has_many :users
  has_many :enemies

  def get_data
    stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
    stats_array = JSON.parse(stats_string)
    stats_array
  end

  def battle
    #create an enemy and save to stage
    enemy = Enemy.new()
    enemy_hash = get_data.sample(1).first
    enemy.save_stats(enemy_hash)
    self.update(enemy_id: enemy.id)

    #print that you're fighting this enemy name
    enemy_url = enemy_hash['images']['md']
    download_image(enemy_url)
    print_picture(enemy_url.split('/').last)
    puts "\n#{enemy.name} entered the room looking to fight you."

    #find the user
    user = User.find(self.user_id)

    #start battle
    until user.hp <= 0 || enemy.hp <= 0
      #initialize temp def for defend action
      user.temp_def = 0
      enemy.temp_def = 0

      #grab enemy input
      enemy_input = enemy_move

      puts "Please pick an action:"
      puts "1.Attack \n2.Defend \n3.Run away\n4.Quit"
      user_input = gets.chomp.to_i

      until user_input > 0 && user_input < 5
        puts "Please enter a valid # for action."
        user_input = gets.chomp.to_i
      end

      exit if user_input == 4

      who_goes_first(user, enemy, user_input, enemy_input)
      sleep(1)
    end

    if user.hp <= 0
      return false
    else
      #we need to move stages
      puts "\nBearded Wizard: Wow! You beat #{enemy.name}!"
      return true
    end
  end

  def who_goes_first(user, enemy, user_input, enemy_input)
    first = true
    if user_input == 3
      run_away(user, enemy)
    elsif enemy_input == 1 #if enemy defends
      defend(enemy)
    end

    case user_input
    when 1
      attack(user, enemy)
      first = false
    when 2
      defend(user)
      first = false
    end

    if enemy_input == 0 && !first #if enemy attacks
      attack(enemy, user)
    end
  end

  def attack(attacker, defender)
    #maybe implement speed difference to see who goes first
    #user attacks
    damage = attacker.atk - (defender.def + defender.temp_def)
    if damage < 0
      damage = 0
    end
    defender.hp -= damage

    puts "\n#{attacker.name} did #{damage} damage to #{defender.name}!"
    puts "#{defender.name} has #{defender.hp} HP left!"
    sleep(1)
  end


  def defend(attacker) #lowers enemy attack and recovers some hp
    attacker.temp_def = (rand(25) + 6)
    if attacker.class == User
      puts "\nYou defended... like a coward."
      puts "But you actually increased your defense by #{attacker.temp_def}."
    elsif attacker.class == Enemy
      puts "\n#{attacker.name} put defenses up!"
      puts "#{attacker.name} increased defense by #{attacker.temp_def}."
    end
  end

  def run_away(user, enemy)
    puts "\nBearded Wizard: HAHAHA you think you can run away???"

    #chance to die cause you tried to run
    die_chance = rand(100)
    case die_chance
    when 0..95
      puts "#{enemy.name} slashed you in the back as you tried to run away, you coward."
      user.hp = 0
    else
      puts "Holy crap, the enemy actually let you run away."
      enemy.hp = 0
    end
  end

  def enemy_move
    #enemy random
    action = rand(20)
    case action
    when 0..14
      return 0
    when 15..19
      return 1
    end
  end
end
