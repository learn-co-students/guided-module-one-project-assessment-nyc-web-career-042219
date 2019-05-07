class User < ActiveRecord::Base
  belongs_to :stage
  has_many :enemies, through: :stages

  def user_stats(superhero_hash)
    user.superhero_name = hero_hash['name']
    user.hp = hero_hash['powerstats']['durability']
    user.atk = hero_hash['powerstats']['strength'] + hero_hash['powerstats']['combat']
    user.def = hero_hash['powerstats']['durability'] + hero_hash['powerstats']['intelligence']
    user.speed = hero_hash['powerstats']['speed']
    user.save
  end

end
