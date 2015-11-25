# Coverage testing
require 'simplecov'
require 'coveralls'

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter[
  SimpleCov::Formatter::HTMLFormatter,
  Coveralls::SimpleCov::Formatter
]
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/rails'
require 'capybara/poltergeist'

Capybara.default_driver = :poltergeist
Capybara.javascript_driver = :poltergeist
require 'webmock/minitest'

I18n.enforce_available_locales = false

class Minitest::Test
  def stub_env(new_env, &block)
    original_env = Rails.env
    Rails.instance_variable_set("@_env", new_env.inquiry)
    block.call
  ensure
    Rails.instance_variable_set("@_env", original_env.inquiry)
  end
end

class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  #
  include Warden::Test::Helpers
  Warden.test_mode!
  setup do
    WebMock.disable_net_connect! allow_localhost: true
  end

  teardown do
    Warden.test_reset!
  end

  def sign_in(user)
    login_as user, scope: :user
  end

  include Capybara::DSL
end
