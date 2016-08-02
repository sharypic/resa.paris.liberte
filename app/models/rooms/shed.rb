module Rooms
  class Shed < Room
    module BookingProperties
      def name
        'Atelier'
      end

      def to_slug
        name.parameterize
      end

      def seats
        20
      end

      def free_time_per_week
        (1.hour + 30.minutes).to_i
      end

      def cost_per_half_hour
        125
      end
    end

    include BookingProperties
    extend BookingProperties
  end
end
