require 'test_helper'

class DatetimeHelperTest < ActionView::TestCase
  setup do
    @year = 2016
    @month = 1
    @day = 1
    @hour = 1
    @minute = 1
    @datetime = Time.zone.local(@year, @month, @day, @hour, @minute)
    @date = Time.zone.local(@year, @month, @day)
  end

  test 'date_to_param serialize year, month and day with 0 padding of 2' do
    date_hash = {
      year: format('%d', @year),
      month: format('%02d', @month),
      day: format('%02d', @day)
    }
    assert_equal date_hash, date_to_param(@datetime)
  end

  test 'datetime_to_param serialize year and m,d,h,m with 0 padding of 2' do
    datetime_hash = {
      year: format('%d', @year),
      month: format('%02d', @month),
      day: format('%02d', @day),
      hour: format('%02d', @hour),
      minute: format('%02d', @minute)
    }
    assert_equal datetime_hash, datetime_to_param(@datetime)
  end

  test 'datetime_from_param works with datetime_to_param' do
    assert_equal @datetime, datetime_from_param(datetime_to_param(@datetime))
  end

  test 'date_from_param works with date_to_param' do
    assert_equal @date, date_from_param(date_to_param(@date))
  end
end
