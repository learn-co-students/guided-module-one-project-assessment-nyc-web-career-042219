class Country < ActiveRecord::Base
  has_many :trips
  has_many :tourists, through: :trips
end
