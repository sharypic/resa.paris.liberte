source 'https://rubygems.org'
ruby '2.3.1'

# 8)
gem 'rails', '~> 5.0.0'

# Backends
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.0'

# Jobs
gem 'delayed_job'
gem 'delayed_job_active_record'
# gem 'delayed_job_web'


# UI
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'bootstrap-sass'

# Admin : not sure good idea to use a branch gem
# gem "administrate", "~> 0.2.2"

gem 'mjml-rails'

# Auth
gem 'devise'
gem 'devise-bootstrap-views'

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'dotenv-rails'
  gem 'rubocop'
  gem 'minitest-perf'
  gem 'annotate'
end

group :development do
  # Access an IRB console on exception pages
  # or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'simplecov', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
