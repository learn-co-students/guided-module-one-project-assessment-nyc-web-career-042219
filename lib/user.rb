class User < ActiveRecord::Base
  belongs_to :stage
  has_many :enemies, through: :stages

  def grab_data
    stats_string = RestClient.get('https://akabab.github.io/superhero-api/api/all.json')
    stats_array = JSON.parse(stats_string)
    stats_array
  end
  
  def user_stats(superhero_name)
    stats = []
    stats_array = grab_data
    stats_array.each do |hero_hash|
      if superhero_name == hero_hash['name']
        self.name = hero_hash['name']

        self.hp = hero_hash['powerstats']['durability']
        self.atk = hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']
        self.def = hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']
        self.speed = hero_hash['powerstats']['speed']
      end
    end
  end

end
