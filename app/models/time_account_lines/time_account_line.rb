# Allow team to pay for more time in room
class TimeAccountLine < ApplicationRecord
  belongs_to :team
end
