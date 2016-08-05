require 'test_helper'

class TestAccount < ActiveSupport::TestCase
  fixtures :rooms, :teams, :residents

  setup do
    @room = rooms(:shed)
    @team = teams(:dev)
    @resident = residents(:mfo)
    @account = Account.new(@team, @shed.class.name)
  end

  test '.balance' do
    assert_equal 0, @account.balance
  end

  test '.balance with a credit line' do
    amount = 10_000
    Credit.create!(team: @team, room_type: @shed.class.name, amount: amount)

    assert_equal amount, @account.balance
  end

  test '.balance with credit and debit lines' do
    reservation = Reservation.create!(name: 'reservation for debit line',
                                      starts_at: Time.zone.today,
                                      ends_at: Time.zone.today + 1.hour,
                                      resident: @resident,
                                      room: @room)
    credit = Credit.create!(team: @team,
                            room_type: @shed.class.name,
                            amount: 1.hour.to_i)
    debit = Debit.create!(team: @team,
                          room_type: @shed.class.name,
                          amount: -reservation.duration_in_seconds,
                          reservation: reservation)

    assert_equal credit.amount + debit.amount, @account.balance
  end
end
