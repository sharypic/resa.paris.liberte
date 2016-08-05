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
    return reservation.save if reservation.team_have_enough_free_seconds?
    return false unless reservation.team_have_enough_paid_seconds?
    safe_reservation_and_debit_create
  end

  private

  def safe_reservation_and_debit_create
    ActiveRecord::Base.transaction do
      amount = reservation.duration_in_seconds
      amount -= team.weekly_free_seconds_available(room,
                                                   reservation.starts_at)
      reservation.save!
      account.debit(reservation, -amount)
    end
  end
end
