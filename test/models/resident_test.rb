require 'test_helper'

class ResidentTest < ActiveSupport::TestCase
  fixtures :residents, :rooms

  test '.fullname fallback use firstname and lastname when present' do
    resident = Resident.new(
      firstname: 'Martin', 
      lastname: 'Fourcade', 
      email: 'fourcade.m@gmail.com'
    )
    assert_equal 'Martin Fourcade', resident.email
  end

  test '.fullname fallbacks to email without firstname and lastname' do
    resident = Resident.new(email: 'fourcade.m@gmail.com')
    assert_equal 'fourcade.m@gmail.com', resident.fullname
  end

  

  test 'usage_of rooms without reservation returns 0' do
    resident = residents(:mfo)

    date = Time.zone.today.beginning_of_week
    Room.list.each do |room|
      assert_equal 0, resident.usage_of(room, date, date + 1.week)
    end
  end

  test 'usage_of Shed with reservation returns expected amount' do
    date = Time.zone.today.beginning_of_week
    resident = residents(:mfo)

    Reservation.create!(starts_at: date + 8.hours,
                        ends_at: date + 9.hours,
                        resident: resident,
                        room: rooms(:shed))

    assert_equal 1.hour.to_i,
                 resident.usage_of(Shed, date, date + 10.hours),
                 'should compute the duration of booked reservation'
    assert_equal 0, resident.usage_of(Square, date, date + 10.hours)
    assert_equal 0, resident.usage_of(Shed, date, date + 5.hours)
    assert_equal 0, resident.usage_of(Square, date, date + 7.hours)
  end
end
