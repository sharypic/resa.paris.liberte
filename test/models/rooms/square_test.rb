require 'test_helper'

module Rooms
  class SquareTest < ActiveSupport::TestCase
    setup do
      @room = Square.new
    end

    test 'name' do
      assert_equal 'Carré', @room.name
    end

    test 'seats' do
      assert_equal 10, @room.seats
    end

    test 'free_time_per_week' do
      assert_equal (2.hours + 30.minutes).to_i, @room.free_time_per_week
    end

    test 'cost_per_half_hour' do
      assert_equal 40, @room.cost_per_half_hour
    end

  end
end
