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

module ActiveSupport
  class TestCase
    self.use_transactional_tests = true

    # Add more helper methods to be used by all tests here...
  end
end
