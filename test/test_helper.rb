require 'simplecov'
SimpleCov.start 'rails' do
  add_filter do |source_file|
    # ignores boilerplates, ex: devise, application_*...
    source_file.lines.count <= 6
  end

  add_group 'Service', 'app/services'
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    self.use_transactional_tests = true

    # Add more helper methods to be used by all tests here...
  end
end
