# Create reservation and credits
class DebitReservation
  attr_reader :reservation, :team, :room, :account

  def initialize(reservation)
    @reservation = reservation
    @team = reservation.team
    @room = reservation.room
    @account = Account.new(@team, @room.type)
  end

  def process
    return save_reservation if reservation.team_have_enough_free_seconds?
    return false unless reservation.team_have_enough_paid_seconds?
    safe_save_reservation_with_debit
  end

  private

  def save_reservation
    reservation.save!
    queue_reservation_create_mail_job
  end

  def safe_save_reservation_with_debit
    ActiveRecord::Base.transaction do
      reservation.save!
      account.debit(reservation, amount_to_debit)
      queue_reservation_create_mail_job
    end
  end

  def amount_to_debit
    amount = reservation.duration_in_seconds
    amount -= team.weekly_free_seconds_available(room,
                                                 reservation.starts_at)
    -amount
  end

  def queue_reservation_create_mail_job
    ReservationCreateMailJob.perform_later(reservation)
  end
end
