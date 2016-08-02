require 'test_helper'

class SignInFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @password = 'okokok'
    @resident = Resident.create!(email: 'fourcade.m@gmail.com',
                             password: @password)
  end

  teardown do
    @resident.destroy
  end

  test 'Homepage structure' do
    get root_url

    assert_select "form[action='#{resident_session_path}']" do
      assert_select 'input[name="resident[email]"]',
                    'Missing email input'
      assert_select 'input[name="resident[password]"]',
                    'Missing password input'
    end

    assert_select ".navbar a[href='#{destroy_resident_session_path}']",
                  false
                  'Logout should not be present when not connected'

  end

  test 'Sign in failure from homepage' do
    post resident_session_path, params: { resident: { email: @resident.email,
                                                      password: "fail" } }

    assert_select '.alert-danger .text-danger',
                  'Invalid Email or password.',
                  'Alert sign in failure missing'
  end

  test 'Sign in success from homepage' do
    post resident_session_path, params: { resident: { email: @resident.email,
                                                      password: @password } }
    follow_redirect!
    assert_select '.alert-info .text-notice',
                  'Signed in successfully.',
                  'Alert sign in success missing'

  end

  test 'Logout from homepage' do
    sign_in(@resident)
    get root_url

    assert_select ".navbar a[href='#{destroy_resident_session_path}']",
                  'Signout'
                  'Logout link missing'

    delete destroy_resident_session_path
    follow_redirect!
    assert_select '.alert-info .text-notice',
                  'Signed out successfully.',
                  'Alert sign out success missing'
  end
end
