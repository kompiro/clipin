source 'https://rubygems.org'

gem 'rails', '4.0.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'nokogiri'
gem 'rails-boilerplate'
gem "rails-backbone"
gem 'eco'
gem 'doorkeeper', '~> 1.0.0'

gem "therubyracer"
gem "less-rails", '2.3.3'
gem "twitter-bootstrap-rails",  "2.2.7"
gem 'spinjs-rails'
gem 'addressable'
# Use unicorn as the app server
#gem 'unicorn'

# Use puma as the app server
gem 'puma'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

end

gem 'coffee-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# for Heroku environment
group :production do
  gem 'pg' , '~> 0.14.1'
end

# use sqlite3 for generationg assets
gem 'sqlite3'

group :development, :test do
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem "cucumber-rails", require: false
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
# gem "jasminerice"
  gem 'sinon-rails'
  gem 'factory_girl'
  gem "factory_girl_rails", "~> 4.3.0"
  gem 'forgery', '0.5.0'
  gem 'pry'
  gem 'pry-doc'
  gem 'fakeweb'
  gem 'sextant'
  # ci
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'ci_reporter'

  # Deploy with Capistrano
  gem 'capistrano','~> 3.1.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-puma', require: false

end

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
