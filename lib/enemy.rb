class Enemy < ActiveRecord::Base
  belongs_to :stage
  has_many :users, through: :stages
end
