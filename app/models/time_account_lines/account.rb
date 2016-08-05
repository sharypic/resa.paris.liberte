# Deals with accounting for a team and different booking
class Account
  attr_reader :team, :room_type

  def initialize(team, room_type)
    @team = team
    @room_type = room_type
  end

  # when a reservation is created
  def debit(reservation)
  end

  # when a user pay for some time
  def credit(amount)
  end

  def balance
    team.time_account_lines
        .where(room_type: room_type)
        .sum(:amount)
  end
end
