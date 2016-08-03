require 'test_helper'

class IndexRoomsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
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
      opts = { room_slug: room.to_slug }
      opts = opts.merge(date_to_param(Time.zone.today))
      url = room_calendars_path(opts)

      assert_select "a[href='#{url}']"
    end
  end
end
