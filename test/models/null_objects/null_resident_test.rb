require 'test_helper'

class NullResidentTest < ActiveSupport::TestCase
  test '.fullname returns empty string' do
    assert_equal '', NullResident.new.fullname
  end
end
