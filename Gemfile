source 'https://rubygems.org'

ruby '2.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem "heroku-api", git: 'https://github.com/heroku/heroku.rb.git', branch: 'master' #no gem with excon dependency >= 0.27 available

gem 'hiredis'
gem 'redis'
gem 'resque'

gem 'responders', '~> 2.0'

gem 'active_model_serializers'

gem 'sass-rails'
gem 'coffee-rails'
gem 'bootstrap-sass'

gem 'uglifier'

gem 'jquery-rails', '=2.0.2'

gem 'fog'

group :production do
  gem 'pg'
  gem 'newrelic_rpm'
  gem 'rails_log_stdout',           git: 'https://github.com/heroku/rails_log_stdout.git', branch: 'master'
  gem 'rails3_serve_static_assets', git: 'https://github.com/heroku/rails3_serve_static_assets.git', branch: 'master'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'sqlite3'
end

group :test do
  gem 'minitest'
  gem 'rspec-rails'
  gem 'factory_girl'
  gem 'shoulda-matchers'
  gem 'webmock'

  gem 'terminal-notifier', '~> 1.6.2'

  gem 'guard-rspec', require: false
  gem 'rspec-nc'
end

