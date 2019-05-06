class Stage < ActiveRecord::Base
  has_many :users
  has_many :enemies

  def grab_data
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

  end

  def attack

  end

  def defend

  end

  def special_move

  end

  def run_away

  end
end
