require 'test_helper'

class IndexRoomsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
  end

  test 'GET rooms_path, redirects to homepage when not signed in' do
    get rooms_path
    assert_redirected_to root_url
  end

  test 'GET rooms_path, responds with success when signed in' do
    sign_in(@resident)
    get rooms_path
    assert_response :success
  end

  test 'GET rooms_path, rendering includes ' \
       'links to room & room denominations' do
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

  test 'GET dated_rooms_path with valid date, ' \
       'shows a date picker with expected date' do
    sign_in(@resident)
    date = Time.zone.today.beginning_of_week

    get dated_rooms_path(date_to_param(date))

    assert_response :success

    date_value_sector = "[value='#{date.strftime('%d-%m-%Y')}']"
    assert_select "#js-initialize-datepicker#{date_value_sector}",
                  true,
                  'can not find initialized datepicker'
  end

  test 'GET dated_rooms_path with invalid date, ' \
       'redirect to rooms_path' do
    sign_in(@resident)

    get dated_rooms_path(year: '2016', month: '44', day: '33')

    assert_redirected_to rooms_path
  end

  test 'GET dated_rooms_path with invalid date, ' \
       'when date is sunday or saturday' do
    sign_in(@resident)
    sunday = Time.zone.today.at_end_of_week
    saturday = sunday.yesterday
    redirect_date = Time.zone.today
    redirect_date = redirect_date.beginning_of_week if day_off?(redirect_date)

    get dated_rooms_path(date_to_param(sunday))
    assert_redirected_to dated_rooms_path(date_to_param(redirect_date))

    get dated_rooms_path(date_to_param(saturday))
    assert_redirected_to dated_rooms_path(date_to_param(redirect_date))
  end
end
