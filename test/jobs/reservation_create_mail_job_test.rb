require 'test_helper'

class ReservationCreateMailJobTest < ActiveJob::TestCase
  fixtures :rooms, :residents

  test '.perform' do
    room = rooms(:shed)
    resident = residents(:mfo)
    reservation = Reservation.create!(id: 1,
                                      name: 'test',
                                      room: room,
                                      resident: resident,
                                      starts_at: Time.zone.today,
                                      ends_at: Time.zone.today +
                                                room.free_time_per_week)

    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      ReservationCreateMailJob.perform_now(reservation)
    end
  end
end
