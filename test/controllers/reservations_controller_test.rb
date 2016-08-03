require 'test_helper'

class ReservationsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  include ::CalendarsHelper

  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
    @room = rooms(:shed)
    @date = Time.zone.today + 8.hours
  end

  test 'redirects to homepage when not signed in' do
    get new_room_reservation_path_with_time(@room.id, @date)
    assert_response :redirect
  end

  test 'redirects to rooms_path when room_id is invalid' do
    sign_in(@resident)

    get new_room_reservation_path_with_time('fail', @date)
    assert_response :redirect
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    sign_in(@resident)

    get new_room_reservation_path_with_time(@room.id, @date)
    assert_response :success
  end
end
