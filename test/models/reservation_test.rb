require 'test_helper'

class ReservationTest < ActiveSupport::TestCase
  setup do
    @starts_at = Time.zone.now
    @ends_at = 2.hours.from_now
    @reservation = Reservation.new(starts_at: @starts_at,
                                   ends_at: @ends_at)
  end

  test '.free_half_hour_consumed with 100 percent free' do
    assert_equal 4, @reservation.free_half_hour_consumed
  end

  test '.safe_time_account_line' do
    assert_equal NullTimeAccountLine,
                 @reservation.safe_time_account_line.class
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

  test '.team_have_enough_free_seconds? blocks creation when reservation ' \
       'duration is too long' do
    reservation = Reservation.new(
      name: 'fail',
      room: rooms(:shed),
      resident: residents(:mfo),
      starts_at: Time.zone.today,
      ends_at: Time.zone.tomorrow
    )
    assert_not reservation.save, 'should not be valid due to too long duration'
    assert_equal 1, reservation.errors.size, 'should have 1 errors'
    assert reservation.errors.key?(:credits), 'ends_at should be in error'
    assert_equal [I18n.t(%w(activerecord
                            errors
                            models
                            reservation
                            attributes
                            credits
                            not_enough).join('.'))],
                 reservation.errors.messages.fetch(:credits)
  end

  test 'fix: .team_have_enough_free_seconds? does not blocks creation ' \
       'when reservation duration in seconds is equal to free seconds' do
    room = rooms(:shed)
    reservation = Reservation.new(
      name: 'fail',
      room: room,
      resident: residents(:mfo),
      starts_at: Time.zone.today,
      ends_at: Time.zone.today + room.free_time_per_week
    )
    assert reservation.save
  end

  test '.team_have_enough_paid_seconds? blocks creation when ' \
       'reservation duration does not fit in free_seconds plus paid_seconds' do
    room = rooms(:shed)
    resident = residents(:mfo)

    reservation = Reservation.new(name: 'fail',
                                  room: room,
                                  resident: resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.tomorrow)
    assert_not reservation.save
  end

  test '.team_have_enough_paid_seconds? allows creation when ' \
       'reservation duration fit in free_seconds plus paid_seconds' do
    room = rooms(:shed)
    resident = residents(:mfo)

    reservation = Reservation.new(name: 'fail',
                                  room: room,
                                  resident: resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.tomorrow)
    Credit.create(room_type: room.type,
                  team: resident.team,
                  amount: 1.day.to_i)
    assert reservation.save
  end

  test '.paid_half_hour_consumed and .paid_half_hour_consumed' do
    room = rooms(:shed)
    resident = residents(:mfo)
    Credit.create(room_type: room.type,
                  team: resident.team,
                  amount: 1.day.to_i)
    reservation = Reservation.new(name: 'fail',
                                  room: room,
                                  resident: resident,
                                  starts_at: Time.zone.today + 8.hours,
                                  ends_at: Time.zone.today + 10.hours)
    DebitReservation.new(reservation).create

    assert_equal 1, reservation.paid_half_hour_consumed
    assert_equal 3, reservation.free_half_hour_consumed
  end

  test '.before_save sets duration_in_seconds' do
    reservation = Reservation.new(name: 'passthru cache_duration_in_seconds',
                                  starts_at: 1.hour.ago,
                                  ends_at: 1.minute.ago,
                                  room: rooms(:shed),
                                  resident: residents(:mfo))
    reservation.save
    reservation.reload
    assert_equal (1.minute.ago.to_i - 1.hour.ago.to_i),
                 reservation.cached_duration_in_seconds
  end

  test '.validates one reservation per room per period' do
    room = rooms(:small_lodge_0)
    resident = residents(:mfo)
    Reservation.create!(name: 'fail',
                        room: room,
                        resident: resident,
                        starts_at: Time.zone.today + 8.hours,
                        ends_at: Time.zone.today + 10.hours)

    assert_not Reservation.new(name: 'fail',
                               room: room,
                               resident: resident,
                               starts_at: Time.zone.today + 8.hours,
                               ends_at: Time.zone.today + 10.hours).valid?
  end
end
