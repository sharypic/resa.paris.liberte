# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Team is a company/association which have
# * many residents able to book a room
class Team < ApplicationRecord
  has_many :residents
  has_many :reservations, through: :residents

  def weekly_free_time_available(room)
    room.free_time_per_week - weekly_consumned_time(room)
  end

  def weekly_consumned_time(room)
    reservations.joins(:room)
                .where(rooms: { type: room.type })
                .this_week
                .sum(&:duration)
  end
end
