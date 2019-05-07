class User < ActiveRecord::Base
  belongs_to :stage
  has_many :enemies, through: :stages

  def save_stats(hero_hash)
    self.superhero_name = hero_hash['name']
    self.hp = hero_hash['powerstats']['durability']
    self.atk = hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']
    self.def = hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']
    self.speed = hero_hash['powerstats']['speed']
    self.save
  end

end
