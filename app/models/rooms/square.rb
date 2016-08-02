module Rooms
  class Square < Room
    module BookingProperties
      def name
        'Carré'
      end

      def seats
        10
      end

      def free_time_per_week
        (2.hour + 30.minutes).to_i
      end

      def cost_per_half_hour
        40
      end
    end

    include BookingProperties
    extend BookingProperties
  end
end
