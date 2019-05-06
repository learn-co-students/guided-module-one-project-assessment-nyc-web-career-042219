class Stage < ActiveRecord::Base
  has_many :users
  has_many :enemies

end
