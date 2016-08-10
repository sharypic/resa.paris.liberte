require 'test_helper'

class ReservationIcalPresenterTest < ActiveSupport::TestCase
  fixtures :rooms, :residents, :teams
  setup do
    @reservation = Reservation.new(name: 'test',
                                   room: rooms(:shed),
                                   resident: residents(:mfo),
                                   starts_at: Time.zone.today,
                                   ends_at:   Time.zone.today + 30.minutes)

    @presenter = ReservationIcalPresenter.new(@reservation)
  end

  test '.populate add event and gives back an icalable calendar' do
    icalendar = @presenter.populate(Icalendar::Calendar.new)

    assert_equal 1, icalendar.events.size, 'event not added to ical'
    assert_nothing_raised { icalendar.to_ical }
  end

  test '.make_ical_reservation_event' do
    ical_event = @presenter.make_ical_reservation_event

    assert_equal @reservation.starts_at, ical_event.dtstart
    assert_equal @reservation.ends_at, ical_event.dtend
    assert_equal @presenter.summary, ical_event.summary
    assert_equal @presenter.description, ical_event.description
    assert_equal ENV['ADDRESS'], ical_event.location
  end

  test '.timezone returns a datetime' do
    assert_equal @presenter.timezone.tzid, Rails.application.config.time_zone
  end

  test '.mailto concat mailto with reservation resident email' do
    assert_equal @presenter.mailto, "mailto:#{@reservation.resident.email}"
  end

  test '.summary concats name & room denomation with sep' do
    sep = ' - '
    assert_equal @presenter.summary, [@reservation.name,
                                      @reservation.room.denomination].join(sep)
  end

  test '.dtstart' do
    assert_equal @presenter.dtstart, @reservation.starts_at
  end

  test '.dtend' do
    assert_equal @presenter.ends_at, @reservation.ends_at
  end
end
