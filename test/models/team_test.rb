require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  fixtures :teams, :residents, :rooms

  test '.weekly_free_time_available without reservations ' \
       'returns room.free_time_per_week' do
    room = rooms(:shed)
    free_time = teams(:staff).weekly_free_time_available(room)
    assert_equal room.free_time_per_week, free_time
  end

  test '.weekly_free_time_available with one reservation from a team member' \
       'returns substract' do
    room = rooms(:shed)
    reservation = residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: Time.zone.today + 8.hours,
      ends_at: Time.zone.today + 9.hours,
      room: room
    )

    free_time = teams(:staff).weekly_free_time_available(room)

    assert_equal room.free_time_per_week - reservation.duration, free_time
  end

  test '.weekly_consumned_time ' \
       'includes reservations on current room' do
    room = rooms(:shed)
    residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: Time.zone.today + 8.hours,
      ends_at: Time.zone.today + 9.hours,
      room: room
    )

    assert_equal 1.hour.to_i,
                 teams(:staff).weekly_consumned_time(room)
  end

  test '.weekly_consumned_time ' \
       'does not includes reservations from other rooms' do
    staff_member = residents(:staff_member)
    room_square = rooms(:square_0)
    room_shed = rooms(:shed)

    staff_member.reservations.create!(
      name: 'meeting',
      starts_at: Time.zone.today + 8.hours,
      ends_at: Time.zone.today + 9.hours,
      room: room_square
    )

    assert_equal 0, teams(:staff).weekly_consumned_time(room_shed)
  end

  test '.weekly_consumned_time ' \
       'does not include reservations from other team' do
    room = rooms(:shed)
    residents(:mfo).reservations.create!(
      name: 'meeting',
      starts_at: Time.zone.today + 8.hours,
      ends_at: Time.zone.today + 9.hours,
      room: room
    )

    assert_equal 0, teams(:staff).weekly_consumned_time(room)
  end

  test '.weekly_consumned_time ' \
       'does not includes reservations outside of this week' do
    room = rooms(:shed)
    residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: 2.weeks.ago,
      ends_at: 2.weeks.ago + 1.hour,
      room: room
    )

    assert_equal 0,
                 teams(:staff).weekly_consumned_time(room)
  end
end
