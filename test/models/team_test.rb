require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  fixtures :teams, :residents, :rooms

  setup do
    @date = Time.zone.today
  end

  test '.weekly_free_seconds_available without reservations ' \
       'returns room.free_seconds_per_week' do
    room = rooms(:shed)

    assert_equal room.free_seconds_per_week,
                 teams(:staff).weekly_free_seconds_available(room, @date),
                 'a team without reservation should have the same amount of ' \
                 'free seconds for a room'
  end

  test '.weekly_free_seconds_available with a reservation returns' \
       'room.free_weekly_seconds minus reservation.duration_in_seconds' do
    room = rooms(:shed)
    reservation = residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: @date + 8.hours,
      ends_at: @date + 9.hours,
      room: room
    )

    assert_equal room.free_seconds_per_week - reservation.duration_in_seconds,
                 teams(:staff).weekly_free_seconds_available(room, @date),
                 'computation of free seconds wrong'
  end

  test '.weekly_free_seconds_consumned ' \
       'includes reservations on current room' do
    room = rooms(:shed)
    residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: @date + 8.hours,
      ends_at: @date + 9.hours,
      room: room
    )

    assert_equal 1.hour.to_i,
                 teams(:staff).weekly_free_seconds_consumned(room, @date),
                 'possible problem with sum of reservation.duration_in_seconds'
  end

  test '.weekly_free_seconds_consumned ' \
       'does not includes reservation from other rooms' do
    staff_member = residents(:staff_member)
    room_square = rooms(:square_0)
    room_shed = rooms(:shed)

    staff_member.reservations.create!(
      name: 'meeting',
      starts_at: @date + 8.hours,
      ends_at: @date + 9.hours,
      room: room_square
    )
    assert_equal 0,
                 teams(:staff).weekly_free_seconds_consumned(room_shed, @date),
                 'possible problem with SQL join on room'
  end

  test '.weekly_free_seconds_consumned ' \
       'does not include reservation from other team' do
    room = rooms(:shed)
    residents(:mfo).reservations.create!(
      name: 'meeting',
      starts_at: @date + 8.hours,
      ends_at: @date + 9.hours,
      room: room
    )

    assert_equal 0,
                 teams(:staff).weekly_free_seconds_consumned(room, @date),
                 'possible problem with team.reservations'
  end

  test '.weekly_free_seconds_consumned ' \
       'does not includes reservation not in given week\'s date' do
    room = rooms(:shed)
    residents(:staff_member).reservations.create!(
      name: 'meeting',
      starts_at: 2.weeks.ago,
      ends_at: 2.weeks.ago + 1.hour,
      room: room
    )

    assert_equal 0,
                 teams(:staff).weekly_free_seconds_consumned(room, @date),
                 'possible problem with for_week'
  end
end
