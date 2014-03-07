source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

# add annotations of schema inside models
gem 'annotate'

# Use form helpers, because we live in the future now
gem 'simple_form'

# Datagrid is nice
gem 'datagrid'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'rails-erd'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
end

# Let's use devise for users
gem 'devise'
gem 'devise_cas_authenticatable'

# Token authentication for partners
gem 'simple_token_authentication'

# CanCan is used for authorization
gem 'cancan'
gem 'httparty'

# Logging is awesome, and paper_trail even more
gem 'paper_trail'

# Njam njam, IBAN
gem 'iban-tools'

group :production, :deployment do
  gem 'puma'
end

# Barcodes
gem 'barcodes', git: "git://github.com/nudded/barcodes"

# Pagination
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'

# WYSIWYG
gem 'ckeditor_rails'

# Statistics
gem 'chartkick'

# Attachements
gem 'paperclip', '~> 3.0'
gem 'spreadsheet'

# Run stuff in the background
gem 'daemons'
gem 'delayed_job', '~> 4.0'
gem 'delayed_job_active_record'
#

# Whenever cronjobs
gem 'whenever', require: false

# Coveralls
gem 'coveralls', require: false

# Deployment
gem 'capistrano', '~> 3.1'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-rvm'

# Stubbing http requests
gem 'webmock', require: false

# export to ical
gem 'ri_cal'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

gem 'airbrake'

group :production do
  gem 'mysql2' # Database
end
