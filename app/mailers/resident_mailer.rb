# Emails sent to resident
class ResidentMailer < ApplicationMailer
  ICAL_ATTACHMENT_NAME = 'invite.ics'.freeze

  def reservation_created(reservation)
    @reservation = reservation
    icalendar = ReservationIcalPresenter.new(reservation)
                                        .populate(Icalendar::Calendar.new)

    attachments[ICAL_ATTACHMENT_NAME] = { mime_type: 'application/ics',
                                          content: icalendar.to_ical }
    mail(to: reservation.resident.email, subject: 'Hello', &:mjml)
  end
end
