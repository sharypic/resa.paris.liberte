module Rooms
  class SmallLodge < Room
    module BookingProperties
      def name
        'Petite loge'
      end

      def to_slug
        name.parameterize
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
end
