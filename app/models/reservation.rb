# == Schema Information
#
# Table name: reservations
#
#  id          :integer          not null, primary key
#  name        :string
#  starts_at   :datetime
#  ends_at     :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  resident_id :integer
#

# Join table between resident and room
class Reservation < ApplicationRecord
  belongs_to :resident
  belongs_to :room

  scope :week_of, lambda { |date|
    from = date.beginning_of_week
    to = from + 1.week
    where('starts_at >= :starts_at AND ends_at <= :ends_at',
          starts_at: from, ends_at: to)
  }

  # Time utils
  def in?(starts_at, ends_at)
    # exact matching
    (self.starts_at == starts_at && self.ends_at == ends_at) ||
      (starts_at > self.starts_at && ends_at <= self.ends_at) ||
      (ends_at <= self.ends_at && starts_at >= self.starts_at)
  end

  def half_hours_used
    DatetimeHelper.seconds_to_half_hour(duration_in_seconds)
  end

  def duration_in_seconds
    (ends_at - starts_at).to_i
  end

  # Rendering helpers
  def mark_as_rendered
    @rendered = true
  end

  def rendered?
    @rendered
  end
end
