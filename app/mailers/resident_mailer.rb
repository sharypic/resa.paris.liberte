# Emails sent to resident
class ResidentMailer < ApplicationMailer
  include DatetimeHelper
  helper_method :date_to_param

  ICAL_ATTACHMENT_NAME = 'invite.ics'.freeze
  INLINE_ICAL_ATTACHMENT_NAME = 'inline-invite.ics'.freeze

  def reservation_created(reservation)
    @reservation = reservation

    attachments[ICAL_ATTACHMENT_NAME] = IcalReservation.new(reservation)
                                                       .to_attachment

    mail(to: reservation.resident.email,
         subject: I18n.t('mail.reservation_created.subject',
                         reservation_name: reservation.name)) do |format|
      format.mjml
      format.text
    end
  end
end
