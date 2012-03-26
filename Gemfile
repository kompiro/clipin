source 'https://rubygems.org'

gem 'rails', '3.2.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'devise'
gem 'nokogiri'
gem "rails-boilerplate"

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
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'cucumber'
  gem "cucumber-rails", require: false
  gem 'webrat'
  gem 'database_cleaner'

  # spork
  gem 'spork', '~> 0.9.0.rc'

  # guard
  gem 'rb-fsevent'
  gem 'guard-spork'
  gem 'guard-rspec'
  gem 'guard-cucumber'

  # notification
  if RUBY_PLATFORM.downcase.include?('linux')
    gem 'libnotify'
    gem 'rb-inotify'
  elsif RUBY_PLATFORM.downcase.include?('darwin')
    gem 'growl'
  end

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
