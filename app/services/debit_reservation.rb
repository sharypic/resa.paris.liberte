# Create reservation and credits
class DebitReservation
  attr_reader :reservation, :team, :room, :account

  def initialize(reservation)
    @reservation = reservation
    @team = reservation.team
    @room = reservation.room
    @account = Account.new(@team, @room.type)
  end

  def create
    return false unless reservation.valid?

    return save_reservation if reservation.team_have_enough_free_seconds?
    return false unless reservation.team_have_enough_paid_seconds?
    safe_save_reservation_with_debit
  end

  private

  def save_reservation
    reservation.save!
    queue_reservation_create_mail_job
  end

  # rubocop:disable Metrics/AbcSize
  def safe_save_reservation_with_debit
    ActiveRecord::Base.transaction do
      amount = reservation.duration_in_seconds
      amount -= team.weekly_free_seconds_available(room,
                                                   reservation.starts_at)
      reservation.save!
      account.debit(reservation, -amount)
      queue_reservation_create_mail_job
    end
  end
  # rubocop:enable Metrics/AbcSize

  def queue_reservation_create_mail_job
    ReservationCreateMailJob.perform_later(reservation)
  end
end
