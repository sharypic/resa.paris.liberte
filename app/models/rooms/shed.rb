# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# STI from room, denominated as "Atelier"
class Shed < Room
  # Booking properties
  module BookingProperties
    def denomination
      'Atelier'
    end

    def to_slug
      denomination.parameterize
    end

    def seats
      20
    end

    def free_seconds_per_week
      (1.hour + 30.minutes).to_i
    end

    def cost_per_half_hour
      125
    end
  end

  include BookingProperties
  extend BookingProperties
end
