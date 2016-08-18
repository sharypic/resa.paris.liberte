# Builder to expose a reservation as an ical
class IcalReservation
  attr_reader :reservation, :calendar

  MIME_TYPE = 'application/ics'.freeze

  def initialize(reservation)
    @reservation = reservation
    @calendar = Icalendar::Calendar.new
    make_calendar
  end

  def to_attachment
    { mime_type: MIME_TYPE, content: render }
  end

  def to_ics
    render
  end

  private

  def render
    calendar.to_ical
  end

  def make_calendar
    reservation_ical_presenter = ReservationIcalPresenter.new(reservation)
    reservation_ical_presenter.populate(calendar)
    calendar
  end
end
