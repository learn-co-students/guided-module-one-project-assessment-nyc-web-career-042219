class Enemy < ActiveRecord::Base
  belongs_to :stage
  has_many :users, through: :stages

  def save_stats(hero_hash)
    self.update(name: hero_hash['name'],
      hp: hero_hash['powerstats']['durability'],
      atk: hero_hash['powerstats']['strength'],
      def: hero_hash['powerstats']['durability'],
      speed: hero_hash['powerstats']['speed'],
      temp_def: 0,
      max_hp: hero_hash['powerstats']['durability'])
  end
end
