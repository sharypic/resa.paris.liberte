require 'test_helper'

class IndexRoomCalendarsControllerTest < ActionDispatch::IntegrationTest
  include DatetimeHelper
  include CalendarsHelper
  include Devise::Test::IntegrationHelpers
  fixtures :teams, :residents, :rooms

  setup do
    @resident = residents(:mfo)
  end

  test 'redirects to homepage when not signed in' do
    opts = { room_slug: 'test' }
    opts = opts.merge(date_to_param(Time.zone.today.beginning_of_week))

    get room_calendars_path(opts)
    assert_redirected_to root_url
  end

  test 'redirects to rooms_path when slug_id is invalid' do
    opts = { room_slug: 'test' }
    opts = opts.merge(date_to_param(Time.zone.today.beginning_of_week))
    sign_in(@resident)

    get room_calendars_path(opts)
    assert_redirected_to rooms_path
  end

  test 'renders calendar when user is sign_in and slug_id valid' do
    sign_in(@resident)
    date = Time.zone.today.beginning_of_week

    Room.list.each do |room_kind|
      opts = { room_slug: room_kind.to_slug }.merge(date_to_param(date))
      get room_calendars_path(opts)

      assert_response :success
      assert_select "table.#{classname_for_room(room_kind.to_slug)}"
      assert_select "table.#{classname_for_date(date)}"
    end
  end

  test 'at beginning of week renders reservations schedule ' \
       'between 8AM and 8PM' do
    travel_to(Time.zone.today.beginning_of_week) do 
      sign_in(@resident)
      date = Time.zone.today.beginning_of_week
      reservations_start = date + 8.hours
      reservations_end = date + 19.hours

      opts = { room_slug: SmallLodge.to_slug }.merge(date_to_param(date))
      get room_calendars_path(opts)

      SmallLodge.all.each do |room|
        opts = { room_id: room.id }
        opts_reservation_begin = opts.merge datetime_to_param(reservations_start)
        opts_reservation_end = opts.merge datetime_to_param(reservations_end)
        url_reservation_begin = new_room_reservations_path opts_reservation_begin
        url_reservation_end = new_room_reservations_path(opts_reservation_end)

        assert_select "a[href='#{url_reservation_begin}']"
        assert_select "a[href='#{url_reservation_end}']"
      end
    end
  end

  test 'redirects to room_calendars of today when date can not be parsed' do
    sign_in(@resident)
    opts = { room_slug: rooms(:shed).to_slug }
    invalid_opts = opts.merge(year: 'a', month: 'b', day: 'c')
    redirect_date = Time.zone.today
    redirect_date = redirect_date.beginning_of_week if day_off?(redirect_date)
    valid_opts = opts.merge(date_to_param(redirect_date))

    get room_calendars_path(invalid_opts)

    assert_redirected_to room_calendars_path(valid_opts)
  end

  test 'redirects to beginning_of_week when date is sunday or saturday' do
    sign_in(@resident)
    opts = { room_slug: rooms(:shed).to_slug }
    sunday = Time.zone.today.at_end_of_week
    saturday = sunday.yesterday

    redirect_date = Time.zone.today
    redirect_date = redirect_date.beginning_of_week if day_off?(redirect_date)
    redirect_path = room_calendars_path(
      opts.merge(date_to_param(redirect_date))
    )

    get room_calendars_path(opts.merge(date_to_param(sunday)))
    assert_redirected_to redirect_path

    get room_calendars_path(opts.merge(date_to_param(saturday)))
    assert_redirected_to redirect_path
  end
end
