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

  test 'error page' do
    get '/500.html'
    assert_select '.dialog h1',
                  'Oops... une erreur est survenue',
                  'missing error message'
    assert_select '.dialog p',
                  'Vous pouvez nous faire un retour à contact@liberte.paris',
                  'missing contact email'
  end
end
