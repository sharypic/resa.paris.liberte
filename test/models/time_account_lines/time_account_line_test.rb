require 'test_helper'

class TimeAccountLineTest < ActiveSupport::TestCase
  test '.half_hours_used' do
    assert_equal 1, Credit.new(amount: 30.minutes.to_i).half_hours_used
    assert_equal -1, Debit.new(amount: -30.minutes.to_i).half_hours_used
  end
end
