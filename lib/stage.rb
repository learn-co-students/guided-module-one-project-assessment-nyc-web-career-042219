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
    self.enemy_id = enemy.id
    self.save

    #print that you're fighting this enemy name

    #find the user

    user = User.find(self.user_id)
    #start battle
    until user.hp <= 0 || enemy.hp <= 0
      puts "Please pick an action:\n"
      puts "1.Attack \n2.Defend \n3.Run away"
      user_action = gets.chomp.to_i
      case user_action
      when 1
        attack(user, enemy)
      when 2
        defend(user, enemy)
      when 3
        run_away(user, enemy)
      else
        puts "Please enter a valid # for action."
      end

      sleep(2)
      enemy_move(user, enemy)
    end

    if user.hp <= 0
      return false
    else
      #we need to move stages
    end
  end

  def attack(attacker, defender)
    #maybe implement speed difference to see who goes first
    #user attacks
    damage = attacker.atk - defender.def
    if damage < 0
      damage = 0
    end
    defender.hp -= damage

    puts "#{attacker.name} did #{damage} to #{defender.name}!"
  end


  def defend(user, enemy) #lowers enemy attack and recovers some hp
    puts "You defended... like a coward."
    user.def += 5

  end

  def run_away(user, enemy)
    puts "Bearded Wizard: HAHAHA you think you can run away???"

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

  def enemy_move(user, enemy)
    #enemy random
    action = rand(10)
    case action
    when 0..6
      #enemy attacks
      attack(enemy, user)
    when 7..9
      #enemy defends

    end
  end
end
