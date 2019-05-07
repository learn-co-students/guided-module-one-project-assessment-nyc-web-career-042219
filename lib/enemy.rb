class Enemy < ActiveRecord::Base
  belongs_to :stage
  has_many :users, through: :stages

  def save_stats(hero_hash)
    self.name = hero_hash['name']
    self.hp = hero_hash['powerstats']['durability']
    self.atk = hero_hash['powerstats']['strength']
    self.def = hero_hash['powerstats']['durability']
    self.speed = hero_hash['powerstats']['speed']
    self.save
  end
end
