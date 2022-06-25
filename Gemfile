source 'https://rubygems.org'

gem 'ed25519', '>= 1.2', '< 2.0'
gem 'bcrypt_pbkdf', '>= 1.0', '< 2.0'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1'
gem 'rails-controller-testing'

# Rails required gems
gem 'bootsnap'
gem 'turbolinks'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use SCSS for stylesheets
gem 'sass-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# add annotations of schema inside models
gem 'annotate'

# Use form helpers, because we live in the future now
gem 'simple_form'

# Datagrid is nice
gem 'datagrid'

# Let's use devise for users
gem 'devise'
gem 'devise_cas_authenticatable', '~> 1.10'

# Omniauth as extra development backdoor
gem 'omniauth-zeuswpi'
gem 'omniauth-rails_csrf_protection'

# Token authentication for partners
gem 'simple_token_authentication'

# CanCan is used for authorization
gem 'cancancan'
gem 'httparty'

# Logging is awesome, and paper_trail even more
gem 'paper_trail'

# Njam njam, IBAN
gem 'iban-tools', git: 'https://github.com/alphasights/iban-tools.git', branch: 'master'



# Barcodes
gem 'barcodes', git: "https://github.com/nudded/barcodes"
gem 'chunky_png'
gem 'barby'

# Pagination
gem 'will_paginate', '~> 3.0'
gem 'will_paginate-bootstrap'

# WYSIYW HTML Editor
gem 'tinymce-rails'

# Statistics
gem 'chartkick'

# Xls
gem 'spreadsheet'

# Whenever cronjobs
gem 'whenever', require: false

# Deployment

# Stubbing http requests
gem 'webmock', require: false

# export to ical
gem 'ri_cal'

# Easy date validations
gem 'validates_timeliness', '~> 6.0.0.beta2'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

#gem 'airbrake', '~> 4.3'

gem 'rmagick'

# select2 is beautiful
gem 'select2-rails'

# Typeahead
gem 'twitter-typeahead-rails'

# Enum support with prefixes
gem 'simple_enum'

# Enable content_tag_for useage
gem 'record_tag_helper'

group :development do
  gem 'rails-erd'

  gem 'capistrano', '~> 3.10'
  gem 'capistrano-rails', '~> 1.6'
  gem 'capistrano-rvm'
  gem 'capistrano-rbenv'

  gem 'listen'
  gem 'letter_opener'
end

group :production do
  gem 'mysql2' # Database
end

group :test do
  gem 'capybara'
  gem 'poltergeist'

  # Temporary lock until the flaky test issue is fixed on Minitest side that's present in 5.16.0
  gem 'minitest', '5.16.1'
end

group :production, :deployment do
  gem 'puma'
end

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

gem "sidekiq", "~> 6.5"
