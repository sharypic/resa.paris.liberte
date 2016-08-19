require 'test_helper'
module Admin
  class ReservationsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :residents, :teams

    setup do
      sign_in(residents(:staff_member))
    end

    test 'index' do
      get admin_team_reservations_url(teams(:staff))
      assert_response :success
    end
  end
end
