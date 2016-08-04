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
  has_many :credit_lines

  def weekly_free_seconds_available(room, date)
    room.free_seconds_per_week - weekly_free_seconds_consumned(room, date)
  end

  def weekly_free_seconds_consumned(room, date)
    type = room.is_a?(Class) ? room.name : room.type

    reservations.joins(:room)
                .where(rooms: { type: type })
                .week_of(date)
                .sum(&:duration_in_seconds)
  end

  def paid_seconds_available(room)
    room_type = room.is_a?(Class) ? room.name : room.type
    room_credit_line = credit_lines.find_by(room_type: room_type)

    if room_credit_line
      room_credit_line.amount
    else
      0
    end
  end
end
