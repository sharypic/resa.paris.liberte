# Preview email send to resident
class ResidentMailerPreview < ActionMailer::Preview
  def reservation_created
    ResidentMailer.reservation_created(Reservation.first)
  end
end
