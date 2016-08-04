require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  setup do
    @starts_at = Time.zone.now
    @ends_at = 2.hours.from_now
    @reservation = Reservation.new(starts_at: @starts_at,
                                   ends_at: @ends_at)
  end

  test '.in? returns true ' \
       'when given starts_at and ends_at are similar to resa dates' do
    assert @reservation.in?(@starts_at, @ends_at)
  end

  test '.in? returns true when given starts arg is in range of resa dates' do
    assert @reservation.in?(@starts_at + 30.minutes, @ends_at)
  end

  test '.in? returns true when given ends arg is in range of resa dates' do
    assert @reservation.in?(@starts_at, @ends_at - 30.minutes)
  end

  test '.in? returns false ' \
       'when given end date is out of range of resa dates' do
    assert_not @reservation.in?(@starts_at, @ends_at + 30.minutes)
  end

  test '.in? returns false when given start is out of range of resa dates' do
    assert_not @reservation.in?(@starts_at - 30.minutes, @ends_at)
  end

  test '.half_hours_used' do
    assert_equal 1, Reservation.new(starts_at: 30.minutes.ago,
                                    ends_at: Time.zone.now).half_hours_used
    assert_equal 2, Reservation.new(starts_at: 1.hour.ago,
                                    ends_at: Time.zone.now).half_hours_used
    assert_equal 4, @reservation.half_hours_used
  end

  test '.duration_in_seconds' do
    assert_equal 30.minutes.to_i,
                 Reservation.new(starts_at: 30.minutes.ago,
                                 ends_at: Time.zone.now).duration_in_seconds
    assert_equal 1.hour.to_i,
                 Reservation.new(starts_at: 1.hour.ago,
                                 ends_at: Time.zone.now).duration_in_seconds
    assert_equal 2.hours.to_i, @reservation.duration_in_seconds
  end

  test '.marks_as_rendered & .rendered?' do
    assert_not @reservation.rendered?
    @reservation.mark_as_rendered
    assert @reservation.rendered?
  end
end

class ReservationWithFixturesTest < ActiveSupport::TestCase
  fixtures :rooms, :residents, :teams

  test '.team_have_enough_free_credits?' do
    reservation = Reservation.new(
      name: 'fail',
      room: rooms(:shed),
      resident: residents(:mfo),
      starts_at: Time.zone.today,
      ends_at: Time.zone.tomorrow
    )
    assert_not reservation.save
    assert_equal 1, reservation.errors.size
    assert reservation.errors.key?(:not_enough_credits)
    error_message = reservation.errors[:not_enough_credits].first
    assert_equal 'Pas assez de crédit', error_message
  end

  test '.team_have_enough_paid_credits?' do
    room = rooms(:shed)
    resident = residents(:mfo)

    reservation = Reservation.new(
      name: 'fail',
      room: room,
      resident: resident,
      starts_at: Time.zone.today,
      ends_at: Time.zone.tomorrow
    )
    assert_not reservation.save

    CreditLine.create(room_type: room.type,
                      team: resident.team,
                      amount: 1.day.to_i)

    assert reservation.save
  end
end
