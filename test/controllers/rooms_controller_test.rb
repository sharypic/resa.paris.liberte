require 'test_helper'

class IndexRoomsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

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
  end

  test 'rendering include links to room & room denominations' do
    sign_in(@resident)
    get rooms_path

    Room.list.each do |room|
      opts = { room_slug: room.to_slug }.merge(date_to_param(Time.zone.today))
      url = room_calendars_path(opts)

      assert_select "#test-#{room.name}" do
        assert_select "a[href='#{url}']",
                      true,
                      "missing #{room.name} link to calendar"
        assert_select 'h2.room-denomination',
                      room.denomination,
                      "missing #{room.name} denomination"
        assert_select 'span.room-seats',
                      room.seats.to_s,
                      "missing #{room.name} seats"
        assert_select 'span.room-cost-per-half-hour',
                      room.cost_per_half_hour.to_s,
                      "missing #{room.name} price per half hour"
      end
    end
  end
end
