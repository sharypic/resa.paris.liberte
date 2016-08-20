# Simple iterator to render a calendar
# from a datetime
# to a datetime
# by step
module CalendarsHelper
  def iterate_day(date, step)
    from = date + 8.hours
    to = date + 20.hours

    while from < to
      next_step = from + step
      yield(from, next_step)
      from = next_step
    end
  end

  def classname_for_room(slug)
    "test-calendar-#{slug}"
  end

  def classname_for_date(date)
    "test-calendar-#{date.strftime('%d-%m-%Y')}"
  end

  def add_to_google_calendar_url(reservation)
    query_options = {
      action: 'TEMPLATE',
      dates: [reservation.starts_at.utc.strftime('%Y%m%dT%H%M%SZ'),
              reservation.ends_at.utc.strftime('%Y%m%dT%H%M%SZ')].join('/'),
      details: reservation.name,
      location: ENV['ADDRESS'],
      text: reservation.name,
      trp: 'false',
      sf: 'true'
    }
    "https://calendar.google.com/calendar/?#{query_options.to_query}"
  end

  def download_reservation_ics_url(reservation)
    room_reservation_url(reservation.room, reservation.id, format: :ics)
  end
end
