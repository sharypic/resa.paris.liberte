require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  test "valid_slug?" do
    assert Room.slug?(Rooms::Shed.to_param)
    assert Room.slug?(Rooms::Square.to_param)
    assert Room.slug?(Rooms::Shed.to_param)
    assert Room.slug?(Rooms::Shed.to_param)
  end
end
