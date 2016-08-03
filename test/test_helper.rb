ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    self.use_transactional_tests = true

    # Add more helper methods to be used by all tests here...
  end
end
