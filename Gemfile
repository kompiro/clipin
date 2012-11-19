source 'https://rubygems.org'

gem 'rails', '3.2.6'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-google-oauth2'
gem 'nokogiri'
gem 'rails-boilerplate'
gem "rails-backbone"
gem 'eco'
gem 'doorkeeper'

gem "therubyracer"
gem "less-rails"
gem "twitter-bootstrap-rails",  "2.1.6"
gem 'spinjs-rails'
gem 'addressable'
# Use unicorn as the app server
gem 'unicorn'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer'

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# for Heroku environment
group :production do
  gem 'pg' , '~> 0.14.1'
end

group :development do
  gem 'thin'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem "cucumber-rails", require: false
  gem 'webrat'
  gem 'database_cleaner'
  gem "jasminerice"
  gem "guard-jasmine"
  gem 'sinon-rails'
  gem 'factory_girl'
  gem "factory_girl_rails", "~> 3.0"
  gem 'forgery', '0.5.0'
  gem 'pry'
  gem 'pry-doc'
  gem 'fakeweb'
  gem 'sextant'
  # ci
  gem 'simplecov', :require => false
  gem 'simplecov-rcov', :require => false
  gem 'ci_reporter'

  # spork
  gem 'spork', '~> 0.9.0.rc'

  # guard
  gem 'rb-fsevent'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'

  # notification
  gem 'growl', :require => false if RUBY_PLATFORM =~ /darwin/i
  # Deploy with Capistrano
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'

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
