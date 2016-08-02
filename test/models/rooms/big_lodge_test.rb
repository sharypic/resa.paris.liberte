require 'test_helper'

class BigLodgeTest < ActiveSupport::TestCase
  setup do
    @room = BigLodge.new
  end

  test 'denomination' do
    assert_equal 'Grande loge', @room.denomination
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

