# Deals with accounting for a team and different booking
class Account
  attr_reader :team, :room_type

  def initialize(team, room_type)
    @team = team
    @room_type = room_type
  end

  def debit(reservation)
  end

  def credit(amount)
  end

  def balance
    team.time_account_lines
        .where(room_type: room_type)
        .sum(:amount)
  end
end
