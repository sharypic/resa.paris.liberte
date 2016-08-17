require 'test_helper'

class NullTimeAccountLineTest < ActiveSupport::TestCase
  test '.amount returns 0' do
    assert_equal 0, NullTimeAccountLine.new.amount
  end
end
