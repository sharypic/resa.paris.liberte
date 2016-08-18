require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :residents

  test 'should get home on request root_url' do
    get root_url
    assert_response :success
  end

  test 'should redirect to rooms_url when logged in' do
    sign_in(residents(:mfo))
    get root_url
    assert_redirected_to rooms_url
  end
end
