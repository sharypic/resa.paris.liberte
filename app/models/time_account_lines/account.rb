# Deals with accounting for a team and different booking
class Account
  class NegativeBalance < StandardError; end

  attr_reader :team, :room_type

  def initialize(team, room_type)
    @team = team
    @room_type = room_type
  end

  # when a reservation is created
  def debit(reservation)
    anticipated_balance = balance - reservation.duration_in_seconds < 0
    raise NegativeBalance, 'not allowed' if anticipated_balance
    Debit.create!(team: team,
                  room_type: room_type,
                  reservation: reservation,
                  amount: -reservation.duration_in_seconds)
  end

  # when a user pay for some time
  def credit(amount)
    Credit.create!(team: team,
                   room_type: room_type,
                   amount: amount)
  end

  def balance
    team.time_account_lines
        .where(room_type: room_type)
        .sum(:amount)
  end
end
