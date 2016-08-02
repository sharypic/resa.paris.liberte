require 'test_helper'

module Rooms
  class BigLodgeTest < ActiveSupport::TestCase
    setup do
      @room = BigLodge.new
    end

    test 'name' do
      assert_equal 'Grande loge', @room.name
    end

    test 'seats' do
      assert_equal 4, @room.seats
    end

    test 'free_time_per_week' do
      assert_equal 5.hours.to_i, @room.free_time_per_week
    end

    test 'cost_per_half_hour' do
      assert_equal 20, @room.cost_per_half_hour
    end
  end
end
