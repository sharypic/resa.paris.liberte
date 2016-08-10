# Emails sent to resident
class ResidentMailer < ApplicationMailer
  def reservation_created(reservation)
    mail(to: reservation.resident.email, subject: 'Hello') do |format|
      format.text
      format.mjml
    end
  end
end
