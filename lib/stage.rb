class Stage < ActiveRecord::Base
  has_many :users
  has_many :enemies

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
      return if enemy.hp <= 0
    when 2
      defend(user); first = false
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

    puts_slowly "\n#{attacker.name} did #{damage} damage to #{defender.name}!".colorize(:red)
    puts_slowly "#{defender.name} has #{defender.hp} HP left!".colorize(:light_green)
  end


  def defend(attacker)
    #increase defense temporarily
    attacker.temp_def = (rand(25) + 6)
    if attacker.class == User
      puts_slowly "\nYou defended... like a coward."
      puts_slowly "But you actually increased your defense by #{attacker.temp_def}.".colorize(:light_blue)
    elsif attacker.class == Enemy
      puts_slowly "\n#{attacker.name} put defenses up!"
      puts_slowly "#{attacker.name} increased defense by #{attacker.temp_def}.".colorize(:light_blue)
    end

    #recover some hp if possible
    # if attacker.hp < attacker.max_hp
    #   attacker.hp += (rand(25) + 6)
    #   if attacker.hp > attacker.max_hp
    #     attacker.hp = attacker.max_hp
    #   end
    # end
  end

  def run_away(user, enemy)
    puts_slowly "\nBearded Wizard: HAHAHA you think you can run away???"

    #chance to die cause you tried to run
    die_chance = rand(100)
    case die_chance
    when 0..95
      puts_slowly "#{enemy.name} slashed you in the back as you tried to run away, you coward.".colorize(:red)
      user.hp = 0
    else
      puts_slowly "Wow, the enemy actually let you run away."
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

  def puts_slowly(text)
    for i in text.chars.to_a
      print i
      sleep(0.02)
    end
    print "\n"
  end
end
