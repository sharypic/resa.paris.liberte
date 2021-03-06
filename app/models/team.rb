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
# * holds paying credits
class Team < ApplicationRecord
  has_many :residents, dependent: :destroy
  has_many :reservations, through: :residents, dependent: :destroy
  has_many :time_account_lines, dependent: :destroy

  def weekly_reservations(date)
    reservations.for_week(date)
                .includes(:resident, :room)
                .order(:starts_at)
  end

  def weekly_free_seconds_available(room, date)
    total = room.free_seconds_per_week -
            weekly_free_seconds_consumned(room, date)
    total = 0 if total < 0
    total
  end

  def weekly_free_seconds_consumned(room, date)
    type = room_type_from_instance_or_class(room)

    reservations.joins(:room)
                .where(rooms: { type: type })
                .for_week(date)
                .sum(:cached_duration_in_seconds)
  end

  def paid_seconds_available(room)
    account(room).balance
  end

  def account(room)
    Account.new(self, room_type_from_instance_or_class(room))
  end

  private

  # room is STI, given an instance or class, gives back STI.type to use in AR
  def room_type_from_instance_or_class(instance_or_class)
    if instance_or_class.is_a?(Class)
      instance_or_class.name
    else
      instance_or_class.type
    end
  end
end
