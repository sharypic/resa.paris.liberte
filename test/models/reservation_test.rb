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

  test 'marks_as_rendered & rendered?' do
    assert_not @reservation.rendered?
    @reservation.mark_as_rendered
    assert @reservation.rendered?
  end
end
