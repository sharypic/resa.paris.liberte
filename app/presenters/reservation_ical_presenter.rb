require 'forwardable'
require 'icalendar/tzinfo'

# Expose reservation data as ical format
class ReservationIcalPresenter
  extend Forwardable
  def_delegators :@reservation, :starts_at, :ends_at

  attr_reader :reservation,
              :tzid,
              :tz,
              :icalendar

  def initialize(reservation)
    @reservation = reservation
    @tzid = Rails.application.config.time_zone
    @tz = TZInfo::Timezone.get tzid
  end

  def populate(icalendar)
    icalendar.add_timezone(timezone)
    icalendar.add_event(make_ical_reservation_event)
    icalendar.publish
    icalendar
  end

  def make_ical_reservation_event
    event = Icalendar::Event.new
    event.dtstart = dtstart
    event.dtend   = dtend
    event.summary = summary
    event.description = description
    event.organizer = mailto
    event.organizer = organizer
    event.location = location
    event
  end

  def location
    ENV['ADDRESS']
  end

  def organizer
    Icalendar::Values::CalAddress.new("mailto:#{reservation.resident.email}",
                                      cn: reservation.team.name)
  end

  def timezone
    tz.ical_timezone(datetime_starts_at)
  end

  def mailto
    "mailto:#{reservation.resident.email}"
  end

  def summary
    "#{reservation.name} - #{reservation.room.denomination}"
  end
  alias description summary

  def dtstart
    Icalendar::Values::DateTime.new(datetime_starts_at, 'tzid' => tzid)
  end

  def dtend
    Icalendar::Values::DateTime.new(datetime_ends_at, 'tzid' => tzid)
  end

  private

  # rubocop:disable Rails/TimeZone
  # Because timezone is managed by Icalendar::Values::Datetime
  def datetime_starts_at
    DateTime.new(*[starts_at.year,
                   starts_at.month,
                   starts_at.day,
                   starts_at.hour,
                   starts_at.min,
                   starts_at.sec])
  end

  def datetime_ends_at
    DateTime.new(*[ends_at.year,
                   ends_at.month,
                   ends_at.day,
                   ends_at.hour,
                   ends_at.min,
                   ends_at.sec])
  end
  # rubocop:enable Rails/TimeZone
end
