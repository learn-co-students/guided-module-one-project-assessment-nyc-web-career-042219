class User < ActiveRecord::Base
  has_many :tickets
  has_many :venues, through: :tickets

end
