# Resident is able to book rooms
class Resident < ApplicationRecord
  devise :database_authenticatable,
         :recoverable,
         :rememberable,
         :trackable,
         :validatable

  belongs_to :team
  has_many :reservations
end
