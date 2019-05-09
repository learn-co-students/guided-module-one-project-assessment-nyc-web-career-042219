class Tourist < ActiveRecord::Base
  has_many :trips
  has_many :countries, through: :trips
end
