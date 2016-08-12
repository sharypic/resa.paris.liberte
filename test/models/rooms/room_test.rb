require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  test 'valid_slug?' do
    assert Room.slug?(Shed.to_slug)
    assert Room.slug?(Square.to_slug)
    assert Room.slug?(Shed.to_slug)
    assert Room.slug?(Shed.to_slug)
  end
end

class RoomScopesTest < ActiveSupport::TestCase
  self.use_instantiated_fixtures = true
  fixtures :teams, :residents, :rooms

  test 'reservations_for_date' do
    starts_at = Time.zone.today + 8.hours
    ends_at = starts_at + 30.minutes
    small_lodge = rooms(:small_lodge_0)

    reservation = Reservation.create(name: 'hello',
                                     starts_at: starts_at,
                                     ends_at: ends_at,
                                     resident: residents(:mfo),
                                     room: small_lodge)

    rooms = SmallLodge.reservations_for_date(Time.zone.today)
    assert_equal 4, rooms.entries.size
    assert_equal small_lodge, rooms.first
    assert_equal reservation, rooms.first.reservations.first
  end
end
