# Emails sent to resident
class ResidentMailer < ApplicationMailer
  ICAL_ATTACHMENT_NAME = 'meeting.ics'.freeze

  def reservation_created(reservation)
    icalendar = Icalendar::Calendar.new
    ical_presenter = ReservationIcalPresenter.new(reservation)
    ical_presenter.populate(icalendar)

    attachments[ICAL_ATTACHMENT_NAME] = { mime_type: 'application/ics',
                                          content: icalendar.to_ical }

    mail(to: reservation.resident.email, subject: 'Hello') do |format|
      format.text
      format.mjml
    end
  end
end
