require 'test_helper'

class DestroyReservationsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
    @room = rooms(:small_lodge_0)
    @date = Time.zone.today + 8.hours
  end

  test 'redirects to homepage when not signed in' do
    reservation = Reservation.create(name: 'Meeting',
                                     starts_at: @date + 1.hour,
                                     ends_at: @date + 2.hours,
                                     room: @room,
                                     resident: @resident)

    delete room_reservation_path(room_id: @room.id,
                                 id: reservation.id)
    assert_redirected_to root_url
  end

  test 'redirects to rooms_path when room_id or id is invalid' do
    reservation = Reservation.create(name: 'Meeting',
                                     starts_at: @date + 1.hour,
                                     ends_at: @date + 2.hours,
                                     room: @room,
                                     resident: @resident)

    sign_in(@resident)

    delete room_reservation_path(room_id: 'none',
                                 id: reservation.id)
    assert_redirected_to rooms_path

    delete room_reservation_path(room_id: @room.id, id: 'none')
    opts = { room_slug: @room.to_slug }.merge(date_to_param(Time.zone.today))
    assert_redirected_to room_calendars_path(opts)
  end

  test 'destroy reservation' do
    reservation = Reservation.create(name: 'Meeting',
                                     starts_at: @date + 1.hour,
                                     ends_at: @date + 2.hours,
                                     room: @room,
                                     resident: @resident)
    sign_in(@resident)
    opts = { room_slug: @room.to_slug }
    opts = opts.merge(date_to_param(reservation.starts_at))

    assert_difference('Reservation.count', -1) do
      delete room_reservation_path(room_id: @room.id,
                                   id: reservation.id)
    end
    assert_redirected_to room_calendars_path(opts)
  end

  test 'forbids to destroy past reservation' do
    past_reservation = Reservation.create!(name: 'Meeting',
                                           starts_at: 2.hours.ago,
                                           ends_at: 1.hour.ago,
                                           room: @room,
                                           resident: @resident)
    sign_in(@resident)
    opts = { room_slug: @room.to_slug }
    opts = opts.merge(date_to_param(past_reservation.starts_at))

    assert_difference('Reservation.count', 0) do
      delete room_reservation_path(room_id: @room.id,
                                   id: past_reservation.id)
    end

    assert_redirected_to room_calendars_path(opts)
  end
end
