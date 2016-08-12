require 'test_helper'

class NewReservationsControllerTest < ActionDispatch::IntegrationTest
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
    assert_redirected_to root_url
  end

  test 'redirects to rooms_path when room_id is invalid' do
    opts = { room_id: 'fail' }.merge(datetime_to_param(@date))
    sign_in(@resident)

    get new_room_reservations_path(opts)
    assert_redirected_to rooms_path
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    opts = { room_id: @room.id }.merge(datetime_to_param(@date))
    sign_in(@resident)

    get new_room_reservations_path(opts)
    assert_response :success
    ends_at = @date + 30.minutes
    assert_select '#reservation_starts_at_1i option' \
                  "[value='#{@date.strftime('%Y')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_starts_at_2i option' \
                  "[value='#{@date.strftime('%-m')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_starts_at_3i option' \
                  "[value='#{@date.strftime('%d')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_starts_at_4i option' \
                  "[value='#{@date.strftime('%H')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_starts_at_5i option' \
                  "[value='#{@date.strftime('%M')}']" \
                  '[selected="selected"]'

    assert_select '#reservation_ends_at_1i option' \
                  "[value='#{ends_at.strftime('%Y')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_ends_at_2i option' \
                  "[value='#{ends_at.strftime('%-m')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_ends_at_3i option' \
                  "[value='#{ends_at.strftime('%d')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_ends_at_4i option' \
                  "[value='#{ends_at.strftime('%H')}']" \
                  '[selected="selected"]'
    assert_select '#reservation_ends_at_5i option' \
                  "[value='#{ends_at.strftime('%M')}']" \
                  '[selected="selected"]'
  end
end
