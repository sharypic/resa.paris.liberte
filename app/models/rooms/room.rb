#
# Style: not raising NotImplemented error because it's for not yet implemented,
#        not abstact
class Room < ApplicationRecord
  has_many :reservations

  scope :reservations_in, -> (starts_at, ends_at) {
    # explicit n+1 query ; easier than left outer join throught AR
    all.entries.map do |room|
      room.reservations
          .where("starts_at >= :starts_at and ends_at <= :ends_at",
                 starts_at: starts_at, ends_at: ends_at)
      room
    end
  }
  # Helperse
  def self.slug?(slug)
    list.map(&:to_slug).include?(slug)
  end

  def self.class_for_slug(slug)
    list.find { |klass| klass.to_slug == slug }
  end

  def self.list
    [
      Shed,
      Square,
      BigLodge,
      SmallLodge
    ]
  end

  # Booking properties
  AbstractError = 'AsbtractMethod, sub class only'.freeze

  # def denomination
  #   raise AbstractError
  # end

  # def seats
  #   raise AbstractError
  # end

  # def free_time_per_week
  #   raise AbstractError
  # end

  # def cost_per_half_hour
  #   raise AbstractError
  # end
end
