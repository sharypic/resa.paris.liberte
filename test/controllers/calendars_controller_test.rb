require 'test_helper'

class IndexRoomCalendarsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents

  setup do
    @resident = residents(:mfo)
  end

  test 'redirects to homepage when not signed in' do
    get room_calendars_path(room_slug: 'test')
    assert_response :redirect
  end

  test 'redirects to rooms_path when slug_id is invalid' do
    sign_in(@resident)

    get room_calendars_path(room_slug: 'test')
    assert_response :redirect
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    sign_in(@resident)

    Room.list.each do |room|
      get room_calendars_path(room_slug: room.to_slug)
      assert_response :success
    end
  end
end
