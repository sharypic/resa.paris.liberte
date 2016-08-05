require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  fixtures :rooms, :teams, :residents

  setup do
    @room = rooms(:shed)
    @team = teams(:dev)
    @resident = residents(:mfo)
    @account = Account.new(@team, @room.class.name)
  end

  def credit_by(amount)
    Credit.create!(team: @team,
                   room_type: @room.class.name,
                   amount: amount)
  end

  test '.balance' do
    assert_equal 0,
                 @account.balance,
                 'balance should be 0 when no TimeAccountLine exists'
  end

  test '.balance with a credit line' do
    amount = 10_000
    Credit.create!(team: @team, room_type: @room.class.name, amount: amount)

    assert_equal amount,
                 @account.balance,
                 'balance should be equal to created credit'
  end

  test '.balance with credit and debit lines' do
    reservation = Reservation.create!(name: 'reservation for debit line',
                                      starts_at: Time.zone.today,
                                      ends_at: Time.zone.today + 1.hour,
                                      resident: @resident,
                                      room: @room)
    credit = credit_by(1.hour.to_i)
    debit = Debit.create!(team: @team,
                          room_type: @room.class.name,
                          amount: -reservation.duration_in_seconds,
                          reservation: reservation)

    assert_equal credit.amount + debit.amount,
                 @account.balance,
                 'balance with credit/debit should be the difference of ' \
                 'both amount'
  end

  test '.debit raise an AccountError if balance goes below zero' do
    reservation = Reservation.new(name: 'reservation for debit line',
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today + 1.hour,
                                  resident: @resident,
                                  room: @room)

    assert_raises(Account::NegativeBalance) do
      @account.debit(reservation, -reservation.duration_in_seconds)
    end
  end

  test '.debit creates a Debit if possible' do
    reservation = Reservation.new(name: 'reservation for debit line',
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today + 1.hour,
                                  resident: @resident,
                                  room: @room)
    credit_by(reservation.duration_in_seconds)

    debit = assert_difference('Debit.count', 1) do
      @account.debit(reservation, -reservation.duration_in_seconds)
    end
    assert_equal debit.reservation, reservation, 'reservation not assigned'
    assert_equal debit.team, @team, 'team not assigned'
    assert_equal debit.amount,
                 -reservation.duration_in_seconds,
                 'amount not negative'
    assert_equal debit.room_type, @room.type, 'room not assigned'
    assert_equal 0, @account.balance, 'balance not updated'
  end

  test '.credit creates a Credit' do
    amount = 30.minutes.to_i
    credit = assert_difference('Credit.count', 1) do
      @account.credit(amount)
    end
    assert_equal credit.team, @team, 'team not assigned'
    assert_equal credit.room_type, @room.type, 'type not assigned'
    assert_equal credit.amount, amount, 'amount not assigned'
    assert_equal amount, @account.balance, 'balance not updated'
  end
end
