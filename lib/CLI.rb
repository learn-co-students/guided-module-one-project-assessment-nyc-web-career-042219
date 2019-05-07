def welcome
  puts "Welcome, please state your name"
  name = gets.chomp #needs to be saved
  User.find_or_create_by(name: name)
end

def confirm


end

def chose_a_hero
  stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
  stats_array = JSON.parse(stats_string)
  sample = stats_array.sample(5)
  i = nil
  while i == nil
    puts "Please pick one of the following\n1.#{sample[0]["name"]} \n2.#{sample[1]["name"]} \n3.#{sample[2]["name"]} \n4.#{sample[3]["name"]} \n5.#{sample[4]["name"]}"
    num = gets.chomp
    num = num.to_i
    if num < 1 || num > 5
      puts "Please enter a valid #"
    else
      i = sample[num-1]
      # put confirm here
    end
  end
end

def stage
  stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
  stats_array = JSON.parse(stats_string)
  sample = stats_array.sample(1)
  name = sample[0]["name"]
  int = sample[0]["powerstats"]["intelligence"]
  str = sample[0]["powerstats"]["strength"]
  spd = sample[0]["powerstats"]["speed"]
  dur = sample[0]["powerstats"]["durability"]
  pwr = sample[0]["powerstats"]["power"]
  cbt = sample[0]["powerstats"]["combat"]

  Enemy.find_or_create_by(name: name, hp: dur, atk: pwr, def: cbt, speed: spd )

  #give them stat
  #loop till someone's hp reach 0
end
