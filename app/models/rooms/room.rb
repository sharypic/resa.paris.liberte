# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# STI Root for Shed, Square, BigLodge, SmallLodge
# Rooms can be booked [via a reservations] by users
# Each kind of room has special booking constraints
class Room < ApplicationRecord
  has_many :reservations

  # explicit n+1 query ; easier than left outer join throught AR
  scope :reservations_in, lambda { |starts_at, ends_at|
    all.entries.map do |room|
      room.reservations
          .where('starts_at >= :starts_at and ends_at <= :ends_at',
                 starts_at: starts_at, ends_at: ends_at)
      room
    end
  }

  # Helpers
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
end
