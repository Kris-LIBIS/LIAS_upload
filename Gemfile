source 'https://rubygems.org'

gem 'rails'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

platforms :jruby do
  gem 'activerecord-jdbc-adapter', :require => false
end

group :development, :test do
  platforms :jruby do
    gem 'jdbc-sqlite3', :require => false
  end
  platforms :ruby do
    gem 'sqlite3', :require => 'sqlite3'
  end
end

# Production
group :production do
  platforms :jruby do
    gem 'jdbc-sqlite3', :require => false
#    gem 'jdbc-mysql'
  end
  platforms :ruby do
    gem 'sqlite3', :require => 'sqlite3'
#    gem 'mysql2'
  end
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  platforms :ruby do
    gem 'therubyracer'
  end
  platforms :jruby do
    gem 'therubyrhino'
  end

  gem 'uglifier'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby'

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