require 'test_helper'

class NullRoomTest < ActiveSupport::TestCase
  test '.denomination returns empty string' do
    assert_equal '', NullRoom.new.denomination
  end

  test '.name returns empty string' do
    assert_equal '', NullRoom.new.name
  end
end
