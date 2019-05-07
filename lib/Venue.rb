class Venue < ActiveRecord::Base
  has_many :users, through: :tickets

end
