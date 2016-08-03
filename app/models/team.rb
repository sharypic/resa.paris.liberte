# Team is a company/association which have
# * many residents able to book a room
class Team < ApplicationRecord
  has_many :residents
  has_many :reservations, through: :residents
end
