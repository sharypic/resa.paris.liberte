require 'test_helper'
module Admin
  class DashboardsControllerTest < ActionDispatch::IntegrationTest
    include Devise::Test::IntegrationHelpers
    fixtures :residents

    test 'redirects to root_url when not signed in' do
      get admin_dashboards_path(@team)
      assert_redirected_to root_url
    end

    test 'redirects to root url when signed in and not admin' do
      sign_in(residents(:mfo))
      get admin_dashboards_path(@team)
      assert_redirected_to root_url
    end

    test 'success when signed in and admin' do
      sign_in(residents(:staff_member))
      get admin_dashboards_path(@team)
      assert_response :success
    end
  end
end
