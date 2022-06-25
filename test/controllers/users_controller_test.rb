# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  test "developer backdoor doesnt work in production" do
    stub_env "production" do
      assert Rails.env.production?
      # Not actually a decent assert as the route didn't exist
      # before the environment change as the routes gets also
      # skipped in the current test environment ¯\_(ツ)_/¯
      assert_raises(ActionController::UrlGenerationError) do
        post :dev_login
      end
    end
  end
end
