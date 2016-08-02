module Rooms
  class BigLodge < Room
    module BookingProperties
      def name
        'Grande loge'
      end

      def seats
        4
      end

      def free_time_per_week
        5.hours.to_i
      end

      def cost_per_half_hour
        20
      end
    end

    include BookingProperties
    extend BookingProperties
  end
end
