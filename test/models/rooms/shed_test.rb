require 'test_helper'

module Rooms
  class ShedTest < ActiveSupport::TestCase
    setup do
      @room = Shed.new
    end

    test 'name' do
      assert_equal 'Atelier', @room.name
    end

    test 'seats' do
      assert_equal 20, @room.seats
    end

    test 'free_time_per_week' do
      assert_equal (1.hour + 30.minutes).to_i, @room.free_time_per_week
    end

    test 'cost_per_half_hour' do
      assert_equal 125, @room.cost_per_half_hour
    end
  end
end
