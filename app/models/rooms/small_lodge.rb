# == Schema Information
#
# Table name: rooms
#
#  id         :integer          not null, primary key
#  type       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# STI from room, denominated as "Petite loge"
class SmallLodge < Room
  # Booking properties
  module BookingProperties
    def denomination
      'Petite loge'
    end

    def to_slug
      denomination.parameterize
    end

    def seats
      2
    end

    def free_time_per_week
      5.hours.to_i
    end

    def cost_per_half_hour
      10
    end
  end

  include BookingProperties
  extend BookingProperties
end
