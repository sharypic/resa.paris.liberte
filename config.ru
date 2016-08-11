# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

if Rails.env.production?
  DelayedJobWeb.use Rack::Auth::Basic do |username, password|
    username == ENV['DJ_USERNAME'] && password == ENV['DJ_PASSWORD']
  end
end
run Rails.application
