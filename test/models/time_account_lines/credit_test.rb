class CreditTest < ActiveSupport::TestCase

  test '.resident returns a NullResident' do
    assert_equal NullResident, Credit.new.resident.class
  end

  test '.room returns a NullRoom' do
    assert_equal NullRoom, Credit.new.room.class
  end

end
