require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  test "valid_slug?" do
    assert Room.slug?(Shed.to_slug)
    assert Room.slug?(Square.to_slug)
    assert Room.slug?(Shed.to_slug)
    assert Room.slug?(Shed.to_slug)
  end
end
