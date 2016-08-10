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

  has_one :team, through: :resident
  has_one :time_account_line, dependent: :destroy

  scope :week_of, lambda { |date|
    from = date.beginning_of_week
    to = from + 1.week
    where('starts_at >= :starts_at AND ends_at <= :ends_at',
          starts_at: from, ends_at: to)
  }

  validate :team_have_enough_credits?, on: :create
  before_save :cache_duration_in_seconds

  # Helpers
  def half_hours_used
    DatetimeHelper.seconds_to_half_hour(duration_in_seconds)
  end

  def duration_in_seconds
    (ends_at.to_i - starts_at.to_i).to_i
  end

  # Before save
  def cache_duration_in_seconds
    self.cached_duration_in_seconds = duration_in_seconds
  end

  # Validations: constraints to book a room
  def team_have_enough_credits?
    if !team_have_enough_free_seconds? && !team_have_enough_paid_seconds?
      errors.add(:not_enough_credits, 'Pas assez de crédit')
    end
  end

  def team_have_enough_free_seconds?
    free_seconds = team.weekly_free_seconds_available(room, starts_at)
    duration_in_seconds <= free_seconds
  end

  def team_have_enough_paid_seconds?
    paid_seconds = team.paid_seconds_available(room)
    total = paid_seconds + team.weekly_free_seconds_available(room, starts_at)
    duration_in_seconds <= total
  end

  # DEVNOTE: this code a nothing to do here.
  # TODO: extract it in a "presenter" for UI [used in calendar view]
  # * in?, same_boundaries?, starts_at_overlap?, ends_at_overlap?
  # * mark_as_rendered, rendered
  def in?(starts_at, ends_at)
    # exact matching
    same_boundaries?(starts_at, ends_at) ||
      starts_at_overlap?(starts_at, ends_at) ||
      ends_at_overlap?(starts_at, ends_at)
  end

  # Rendering state helpers
  def mark_as_rendered
    @rendered = true
  end

  def rendered?
    @rendered
  end

  private

  # Sweetness to make time comparison more readable
  def same_boundaries?(starts_at, ends_at)
    self.starts_at == starts_at && self.ends_at == ends_at
  end

  def starts_at_overlap?(starts_at, ends_at)
    starts_at > self.starts_at && ends_at <= self.ends_at
  end

  def ends_at_overlap?(starts_at, ends_at)
    ends_at <= self.ends_at && starts_at >= self.starts_at
  end
end
