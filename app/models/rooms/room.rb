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
  has_many :time_account_lines

  # explicit n+1 query ; easier than left outer join throught AR
  # with n<=4 [acceptable]
  scope :reservations_for_date, lambda { |date|
    starts_at = date + 8.hours
    ends_at = date + 20.hours

    all.entries.map do |room|
      room.reservations
          .where('starts_at >= :starts_at and ends_at <= :ends_at',
                 starts_at: starts_at, ends_at: ends_at)
      room
    end
  }

  def name
    denomination
  end

  # Helpers
  def self.list
    [
      Shed,
      Square,
      BigLodge,
      SmallLodge
    ]
  end

  def self.class_for_string(room_type_as_string)
    Object.const_get(room_type_as_string)
  end

  def self.slugs
    list.map(&:to_slug)
  end

  def self.slug?(slug)
    slugs.include?(slug)
  end

  def self.class_for_slug(slug)
    list.find { |klass| klass.to_slug == slug }
  end
end
