# reservation_create_mail_job.rb
class ReservationCreateMailJob < ApplicationJob
  def perform(reservation)
    ResidentMailer.reservation_created(reservation).deliver
  end
end
