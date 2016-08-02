require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test 'should get home on request root_url' do
    get root_url
    assert_response :success
  end
end
