class User < ActiveRecord::Base
  has_many :lists
  has_many :movies, through: :lists

end
