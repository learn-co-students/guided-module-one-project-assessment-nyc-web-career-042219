class User < ActiveRecord::Base
  belongs_to :stage
  has_many :enemies, through: :stage
end
