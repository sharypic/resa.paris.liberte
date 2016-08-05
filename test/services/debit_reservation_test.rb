require 'test_helper'

class DebitReservationTest < ActiveSupport::TestCase
  fixtures :teams, :rooms, :residents
  setup do
    @team = teams(:dev)
    @room = rooms(:shed)
    @resident = residents(:mfo)
  end

  test '.process reservation need too much time and not credits' do
    reservation = Reservation.new(name: 'test',
                                  room: @room,
                                  resident: @resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today +
                                            @room.free_time_per_week +
                                            30.minutes)
    assert_not DebitReservation.new(reservation).process
  end

  test '.process reservation decreate account.balance' do
    account = Account.new(@team, @room.type)
    account.credit(1.hour.to_i)
    reservation = Reservation.new(name: 'test',
                                  room: @room,
                                  resident: @resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today +
                                            @room.free_time_per_week +
                                            30.minutes)
    assert_difference('Reservation.count + Debit.count', 2) do
      DebitReservation.new(reservation).process
    end
    assert_equal 30.minutes.to_i, account.balance
  end
end
