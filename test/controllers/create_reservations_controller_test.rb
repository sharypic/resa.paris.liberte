require 'test_helper'

class CreateReservationsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @room = rooms(:shed)
    @starts_at = Time.zone.today + 8.hours
    @ends_at = Time.zone.today + 9.hours
    @reservation_params = {
      reservation: {
        :room_id => @room.id,
        :name => 'Created Reservation',
        :'starts_at(1i)' => @starts_at.strftime('%Y'),
        :'starts_at(2i)' => @starts_at.strftime('%-m'),
        :'starts_at(3i)' => @starts_at.strftime('%-d'),
        :'starts_at(4i)' => @starts_at.strftime('%H'),
        :'starts_at(5i)' => @starts_at.strftime('%M'),
        :'ends_at(1i)' => @ends_at.strftime('%Y'),
        :'ends_at(2i)' => @ends_at.strftime('%-m'),
        :'ends_at(3i)' => @ends_at.strftime('%-d'),
        :'ends_at(4i)' => @ends_at.strftime('%H'),
        :'ends_at(5i)' => @ends_at.strftime('%M')
      }
    }
  end

  test 'post redirects to homepage when not signed in' do
    opts = { room_id: @room.id }.merge(datetime_to_param(@starts_at))

    post room_reservations_path(opts)
    assert_redirected_to root_url
  end

  test 'post with valid data redirects to rooms calendar' do
    sign_in(residents(:mfo))
    url_opts = { room_id: @room.id }.merge(datetime_to_param(@starts_at))

    post room_reservations_path(url_opts), params: @reservation_params

    redirect_url_opts = { room_slug: @room.to_slug }
    redirect_url_opts = redirect_url_opts.merge(date_to_param(@starts_at))
    assert_redirected_to room_calendars_path(redirect_url_opts)
  end

  test 'post with valid data create the reservation' do
    sign_in(residents(:mfo))
    url_opts = { room_id: @room.id }.merge(datetime_to_param(@starts_at))

    assert_difference('Reservation.count', 1) do
      post room_reservations_path(url_opts), params: @reservation_params
    end

    reservation = Reservation.first
    assert_equal @room, reservation.room
    assert_equal residents(:mfo), reservation.resident
    assert_equal 'Created Reservation', reservation.name
    assert_equal @starts_at, reservation.starts_at
    assert_equal @ends_at, reservation.ends_at
  end
end
