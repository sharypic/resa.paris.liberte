require 'test_helper'

class IndexRoomCalendarsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents

  setup do
    @resident = residents(:mfo)
  end

  test 'redirects to homepage when not signed in' do
    opts = { room_slug: 'test' }.merge(date_to_param(Time.zone.today))

    get room_calendars_path(opts)
    assert_redirected_to root_url
  end

  test 'redirects to rooms_path when slug_id is invalid' do
    opts = { room_slug: 'test' }.merge(date_to_param(Time.zone.today))
    sign_in(@resident)

    get room_calendars_path(opts)
    assert_redirected_to rooms_path
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    sign_in(@resident)

    Room.list.each do |room|
      opts = { room_slug: room.to_slug }.merge(date_to_param(Time.zone.today))
      get room_calendars_path(opts)
      assert_response :success
    end
  end
end
