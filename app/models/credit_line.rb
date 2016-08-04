# Allow team to pay for more time in room
class CreditLine < ApplicationRecord
  belongs_to :team
end
