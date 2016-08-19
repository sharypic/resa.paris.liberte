require 'test_helper'

class ResidentTest < ActiveSupport::TestCase
  fixtures :residents, :rooms
  test '.fullname concat firstname and lastname' do
    resident = Resident.new(firstname: 'Martin', lastname: 'Fourcade')
    assert_equal 'Martin Fourcade', resident.fullname
  end

  test 'usage_of rooms without reservation returns 0' do
    resident = residents(:mfo)

    Room.list.each do |room|
      assert_equal 0, resident.usage_of(room)
    end
  end

  test 'usage_of Shed with reservation returns expected amount' do
    date = Time.zone.today.beginning_of_week
    resident = residents(:mfo)

    Reservation.create!(starts_at: date + 8.hours,
                        ends_at: date + 9.hours,
                        resident: resident,
                        room: rooms(:shed))

    assert_equal 1.hour.to_i, resident.usage_of(Shed)
    assert_equal 0, resident.usage_of(Square)
    assert_equal 0, resident.usage_of(SmallLodge)
    assert_equal 0, resident.usage_of(BigLodge)
  end
end
