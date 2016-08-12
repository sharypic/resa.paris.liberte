require 'test_helper'

class DateParserTest < ActiveSupport::TestCase
  include DatetimeHelper
  class FakeController
    include DateParser
  end

  setup do
    @date_parser = FakeController.new
  end

  test '.date_or_default with bad format raises MalformattedDateError' do
    assert_raises(DateParser::MalformattedDateError) do
      @date_parser.date_or_default(year: 'abc', month: '123', day: 'ko')
    end
  end

  test '.date_or_default with valid format but on sunday' do
    date = Time.zone.today.at_end_of_week

    assert_raises(DateParser::DayOffError, 'how dare you') do
      @date_parser.date_or_default(date_to_param(date))
    end
  end

  test 'date_or_default without date params, return default_date' do
    assert_equal @date_parser.default_date, @date_parser.date_or_default({})
  end
end
