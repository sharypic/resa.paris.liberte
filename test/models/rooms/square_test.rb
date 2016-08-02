require 'test_helper'

class SquareTest < ActiveSupport::TestCase
  setup do
    @room = Square.new
  end

  test 'denomination' do
    assert_equal 'Carré', @room.denomination
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

