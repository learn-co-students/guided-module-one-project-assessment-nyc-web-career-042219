class User < ActiveRecord::Base
  has_many :venues, through: :tickets

end
