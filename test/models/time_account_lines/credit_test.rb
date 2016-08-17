class CreditTest < ActiveSupport::TestCase
  test '.resident returns a NullObjects::Resident' do
    assert_equal NullObjects::Resident, Credit.new.resident.class
  end

  test '.room returns a NullObjects::Room' do
    assert_equal NullObjects::Room, Credit.new.room.class
  end
end
