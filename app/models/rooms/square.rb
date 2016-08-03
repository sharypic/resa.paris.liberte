# STI from room, denominated as "Carre"
class Square < Room
  # Booking properties
  module BookingProperties
    def denomination
      'Carré'
    end

    def to_slug
      denomination.parameterize
    end

    def seats
      10
    end

    def free_time_per_week
      (2.hours + 30.minutes).to_i
    end

    def cost_per_half_hour
      40
    end
  end

  include BookingProperties
  extend BookingProperties
end
