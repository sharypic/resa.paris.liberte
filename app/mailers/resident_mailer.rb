# Emails sent to resident
class ResidentMailer < ApplicationMailer
  include DatetimeHelper
  helper_method :date_to_param

  ICAL_ATTACHMENT_NAME = 'invite.ics'.freeze

  def reservation_created(reservation)
    @reservation = reservation
    icalendar = make_ical_for_reservation(reservation)
    attachments[ICAL_ATTACHMENT_NAME] = { mime_type: 'application/ics',
                                          content: icalendar.to_ical }
    mail(to: reservation.resident.email,
         subject: I18n.t('mail.reservation_created.subject',
                         reservation_name: reservation.name)) do |format|
      format.mjml
      format.text
    end
  end

  private

  def make_ical_for_reservation(reservation)
    icalendar = Icalendar::Calendar.new
    reservation_ical_presenter = ReservationIcalPresenter.new(reservation)
    reservation_ical_presenter.populate(icalendar)
    icalendar
  end
end
