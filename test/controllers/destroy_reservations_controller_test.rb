require 'test_helper'

class DestroyReservationsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
    @room = rooms(:shed)
    @date = Time.zone.today + 8.hours
    @reservation = Reservation.create(name: 'Meeting',
                                      starts_at: @date,
                                      ends_at: @date + 1.hour,
                                      room: @room,
                                      resident: @resident)
  end

  test 'redirects to homepage when not signed in' do
    delete room_reservation_path(room_id: @room.id,
                                 id: @reservation.id)
    assert_redirected_to root_url
  end

  test 'redirects to rooms_path when room_id or id is invalid' do
    sign_in(@resident)

    delete room_reservation_path(room_id: 'none',
                                 id: @reservation.id)
    assert_redirected_to rooms_path

    delete room_reservation_path(room_id: @room.id, id: 'none')
    opts = { room_slug: @room.to_slug }.merge(date_to_param(Time.zone.today))
    assert_redirected_to room_calendars_path(opts)
  end

  test 'destroy reservation' do
    sign_in(@resident)
    opts = { room_slug: @room.to_slug }
    opts = opts.merge(date_to_param(@reservation.starts_at))

    assert_difference('Reservation.count', -1) do
      delete room_reservation_path(room_id: @room.id,
                                   id: @reservation.id)
    end
    assert_redirected_to room_calendars_path(opts)
  end
end
