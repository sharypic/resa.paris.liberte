# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# STI from room, denominated as "Grande loge"
class BigLodge < Room
  # Booking properties
  module BookingProperties
    def denomination
      'Grande loge'
    end

    def to_slug
      denomination.parameterize
    end

    def seats
      4
    end

    def free_seconds_per_week
      5.hours.to_i
    end

    def cost_per_half_hour
      20
    end
  end

  include BookingProperties
  extend BookingProperties
end
