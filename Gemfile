ruby '2.2.2'
source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.3'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
gem 'eco'
gem 'coffeebeans'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'bourbon'
gem 'neat'

gem 'devise'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'cancancan', '~> 1.10'
gem 'gravatarify', '~> 3.0.0'
gem 'inline_svg'

gem 'stringex'
gem 'auto_strip_attributes', '~> 2.0'
gem 'geocoder'
gem 'money-rails'
gem 'redcarpet'
gem 'will_paginate'

gem 'active_model_serializers', github: 'rails-api/active_model_serializers', ref: '39d6dab218777defe8df251651d03517c7ddf35f'

gem 'i18n-js', '>= 3.0.0.rc11'

gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'colorize'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'rollbar', '~> 1.2.7'

gem 'simplecov', require: false, group: :test
gem "codeclimate-test-reporter", group: :test, require: nil

group :production do
  gem 'rails_12factor'
end

group :development do
  gem 'letter_opener'
  gem 'quiet_assets'
  gem 'bullet'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  gem 'rspec-rails'
  gem 'rspec-collection_matchers'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'

  gem 'fontcustom'
end
