require 'test_helper'
module Admin
  class ReservationsTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :residents, :teams

    include AssertAuthAdmin
    test 'authentication' do
      url = admin_team_reservations_url(teams(:staff))
      redirects_to_root_url_non_authenticate_admin(url)
    end

    test 'index' do
      sign_in(residents(:staff_member))
      get admin_team_reservations_url(teams(:staff))
      assert_response :success
    end
  end
end
