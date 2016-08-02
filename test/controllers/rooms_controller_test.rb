require 'test_helper'

class IndexRoomsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'redirect to homepage when not signed in' do
    get rooms_path
    assert_response :redirect
  end

  test 'responds with success when signed in' do
    resident = Resident.create!(email: 'fourcade.m@gmail.com',
                                password: 'okokok')

    sign_in(resident)
    get rooms_path
    assert_response :success
  end
end
