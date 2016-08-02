require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home' do
    get pages_home_url
    assert_response :success
  end

  test 'should get home on request root_url' do
    get root_url
    assert_response :success
    assert_select 'input[name="user[email]"]'
    assert_select 'input[name="user[password]"]'
  end
end
