# Join table between resident and room
class Reservation < ApplicationRecord
  belongs_to :resident
  belongs_to :room

  # Time utils
  def in?(starts_at, ends_at)
    # exact matching
    (self.starts_at == starts_at && self.ends_at == ends_at) ||
    (starts_at > self.starts_at && ends_at <= self.ends_at) ||
    (ends_at <= self.ends_at && starts_at >= self.starts_at)
  end

  def half_hours_used
    (ends_at.to_i - starts_at.to_i) / 30.minutes.to_i
  end

  # Rendering helpers
  def mark_as_rendered
    @rendered = true
  end

  def rendered?
    !!@rendered
  end
end
