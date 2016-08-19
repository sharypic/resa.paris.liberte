require 'simplecov'
SimpleCov.start 'rails' do
  # ignores boilerplates, ex: devise, application_*...
  add_filter do |source_file|
    source_file.lines.count <= 5
  end

  add_group 'Service',      'app/services'
  add_group 'Presenter',    'app/presenter'
  add_group 'Concern',      'app/controllers/concerns'
  add_group 'NullObjects',  'app/models/null_objects'
  add_group 'Accounting',   'app/models/time_account_lines'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module AssertAuthAdmin
  def redirects_to_root_url_non_authenticate_admin(url)
    # test 'redirects to root_url when not signed in' do
      get url
      assert_redirected_to root_url
    # end
    # test 'redirects to root url when signed in and not admin' do
      sign_in(residents(:mfo))
      get url
      assert_redirected_to root_url
    # end
    # test 'success when signed in and admin' do
      sign_in(residents(:staff_member))
      get url
      assert_response :success
    # end
  end
end

module ActiveSupport
  class TestCase
    self.use_transactional_tests = true

    # Add more helper methods to be used by all tests here...
  end
end
