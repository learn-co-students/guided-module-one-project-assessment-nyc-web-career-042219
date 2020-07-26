class Trip < ActiveRecord::Base
  belongs_to :tourist
  belongs_to :country
end
