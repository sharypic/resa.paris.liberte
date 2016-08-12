require 'test_helper'

class ResidentTest < ActiveSupport::TestCase
  test '.fullname concat firstname and lastname' do
    resident = Resident.new(firstname: 'Martin', lastname: 'Fourcade')
    assert_equal 'Martin Fourcade', resident.fullname
  end
end
