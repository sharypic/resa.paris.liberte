require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
    @room = rooms(:shed)
    @date = Time.zone.today + 8.hours
  end

  test 'redirects to homepage when not signed in' do
    opts = { room_id: @room.id }.merge(datetime_to_param(@date))

    get new_room_reservations_path(opts)
    assert_response :redirect
  end

  test 'redirects to rooms_path when room_id is invalid' do
    opts = { room_id: 'fail' }.merge(datetime_to_param(@date))
    sign_in(@resident)

    get new_room_reservations_path(opts)
    assert_response :redirect
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    opts = { room_id: @room.id }.merge(datetime_to_param(@date))
    sign_in(@resident)

    get new_room_reservations_path(opts)
    assert_response :success
  end
end
