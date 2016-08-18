require 'test_helper'
module Admin
  class TimeAccountLinesTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :residents, :teams

    setup do
      sign_in(residents(:staff_member))
    end

    test 'index' do
      get admin_team_time_account_lines_path(teams(:staff))
      assert_response :success
    end

    test 'create' do
      assert_difference('Credit.count', 1) do
        post admin_team_time_account_lines_path(teams(:staff)), params: {
          credit: {
            amount: 2,
            room_type: Shed.name
          }
        }
      end
    end
  end
end
