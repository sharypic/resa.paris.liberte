require 'test_helper'
# Test sign success & failure as well as sign out
class AuthenticationFlowsTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  fixtures :residents, :teams

  setup do
    @password = 'guillaume'
    @resident = residents(:mfo)
  end

  test 'Homepage structure' do
    get root_url

    assert_select "form[action='#{resident_session_path}']" do
      assert_select 'input[name="resident[email]"]',
                    true,
                    'Missing email input'
      assert_select 'input[name="resident[password]"]',
                    true,
                    'Missing password input'
    end

    assert_select ".navbar a[href='#{destroy_resident_session_path}']",
                  false,
                  'Logout should not be present when not connected'
  end

  test 'Sign in failure from homepage' do
    post resident_session_path, params: { resident: { email: @resident.email,
                                                      password: 'fail' } }
    follow_redirect!
    assert_select '.alert-danger .text-danger',
                  I18n.t('devise.failure.invalid'),
                  'Alert sign in failure missing'
  end

  test 'Sign in success from homepage' do
    post resident_session_path, params: { resident: { email: @resident.email,
                                                      password: @password } }
    follow_redirect!
    assert_select '.navbar-team', @resident.team.name
    assert_select '.alert-info .text-notice', false
  end

  test 'Logout from homepage' do
    sign_in(@resident)
    get root_url
    follow_redirect!

    assert_select ".navbar a[href='#{destroy_resident_session_path}']",
                  I18n.t('devise.shared.links.sign_out'),
                  'Logout link missing'

    delete destroy_resident_session_path
    follow_redirect!
    assert_select '.alert-info .text-notice',
                  I18n.t('devise.sessions.signed_out'),
                  'Alert sign out success missing'
  end
end
