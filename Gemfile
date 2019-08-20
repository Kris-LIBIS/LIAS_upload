source 'https://rubygems.org'

gem 'rails', '>= 5.0.7'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

platforms :jruby do
  gem 'activerecord-jdbc-adapter', :require => false
end

platforms :jruby do
  gem 'jdbc-sqlite3', :require => false
#  gem 'jdbc-mysql'
end
platforms :ruby do
  gem 'sqlite3', :require => 'sqlite3'
#  gem 'mysql2'
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', '>= 5.0.7'
  gem 'coffee-rails', '>= 4.1.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  platforms :ruby do
    gem 'therubyracer'
  end
  platforms :jruby do
    gem 'therubyrhino'
  end

  gem 'uglifier'
end

gem 'jquery-rails', '>= 4.1.1'

# To use ActiveModel has_secure_password
gem 'bcrypt'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

# User better web server
platforms :jruby do
  gem 'trinidad'
end
platforms :ruby do
  gem 'thin'
end

gem 'SyslogLogger', '~> 2.0'

# gem  'will_paginate', '~> 3.0'

gem 'rvm-capistrano'

gem 'capistrano-deploytags'
