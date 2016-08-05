# Deals with accounting for a team and different booking
class Account
  class NegativeBalance < StandardError; end
  class InvalidDebit < StandardError; end

  attr_reader :team, :room_type

  def initialize(team, room_type)
    @team = team
    @room_type = room_type
  end

  # when a reservation is created
  def debit(reservation, negative_amount = nil)
    raise NegativeBalance, 'not allowed' if balance + negative_amount < 0

    Debit.create!(team: team,
                  room_type: room_type,
                  reservation: reservation,
                  amount: negative_amount)
  end

  # when a user pay for some time
  def credit(postive_amount)
    Credit.create!(team: team,
                   room_type: room_type,
                   amount: postive_amount)
  end

  def balance
    team.time_account_lines
        .where(room_type: room_type)
        .sum(:amount)
  end
end
