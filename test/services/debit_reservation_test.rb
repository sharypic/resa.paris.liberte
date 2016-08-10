require 'test_helper'

class DebitReservationTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper
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
    assert_enqueued_jobs 0 do
      assert_not DebitReservation.new(reservation).process
    end
  end

  test '.process reservation with free credits' do
    reservation = Reservation.new(id: 1,
                                  name: 'test',
                                  room: @room,
                                  resident: @resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today +
                                            @room.free_time_per_week)
    assert_enqueued_with(job: ReservationCreateMailJob,
                         args: [reservation]) do
      assert_difference('Reservation.count', 1) do
        DebitReservation.new(reservation).process
      end
      assert_equal 0, Debit.count, 'free reservation should not create credit'
    end
  end

  test '.process reservation with paying credits decreases account.balance' do
    account = Account.new(@team, @room.type)
    account.credit(1.hour.to_i)
    reservation = Reservation.new(id: 1,
                                  name: 'test',
                                  room: @room,
                                  resident: @resident,
                                  starts_at: Time.zone.today,
                                  ends_at: Time.zone.today +
                                            @room.free_time_per_week +
                                            30.minutes)
    assert_enqueued_with(job: ReservationCreateMailJob,
                         args: [reservation]) do
      assert_difference('Reservation.count + Debit.count', 2) do
        DebitReservation.new(reservation).process
      end
      assert_equal 30.minutes.to_i, account.balance
    end
  end
end
