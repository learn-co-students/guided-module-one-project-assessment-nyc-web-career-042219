class Stage < ActiveRecord::Base
  has_many :users
  has_many :enemies

  def get_data
    stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
    stats_array = JSON.parse(stats_string)
    stats_array
  end

  def get_stats(user_or_enemy)
    stats = []
    stats_array = grab_data
    stats_array.each do |hero_hash|
      if superhero_name == hero_hash['name']
        user_or_enemy.name = hero_hash['name']

        user_or_enemy.hp = hero_hash['powerstats']['durability']
        user_or_enemy.atk = hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']
        user_or_enemy.def = hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']
        user_or_enemy.speed = hero_hash['powerstats']['speed']
      end
    end
  end

  def battle
<<<<<<< HEAD
    until User.find(self.user_id) < 0 || Enemy.find(self.enemy_id) < 0
      puts "Please pick an action:\n"
      puts "1.Attack \n2.Defend \n3.Run away"
      user_action = gets.chomp
      if user_action < 1 || user_action > 4
        puts "Please enter a valid #"
      elsif user_action == 1
        attack
      elsif user_action == 2
        defend
      elsif user_action == 3
        run_away
      end
=======
  until User.find(self.user_id) < 0 || Enemy.find(self.enemy_id) < 0
    puts "Please pick an action:\n"
    puts "1.Attack \n2.Defend \n3.Run away"
    user_action = gets.chomp
    if user_action < 1 || user_action > 4
      puts "Please enter a valid #"
    elsif user_action == 1
      attack
    elsif user_action == 2
      defend
    elsif user_action == 3
      run_away
    end
>>>>>>> master

    end
  end
end

def attack(attacker)
  if attacker.class == User
  damage = attacker.atk - Enemy.find(self.enemy_id)
    if damage < 0
      damage = 0
    end
  end
  if attacker.class == Enemy
    damage = attacker.atk - User.find(self.user_id)
    if damage < 0
      damage = 0
    end
  end
end


  def defend #lowers enemy attack and recovers some hp

  end

  def run_away

  end
end
