require 'test_helper'

class IndexRoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents

  setup do
    @resident = residents(:mfo)
  end

  test 'redirects to homepage when not signed in' do
    get rooms_path
    assert_response :redirect
  end

  test 'responds with success when signed in' do
    sign_in(@resident)
    get rooms_path
    assert_response :success

    Room.list.each do |room|
      assert_select "a[href='#{room_calendars_path(room.to_slug)}']"
    end
  end
end
