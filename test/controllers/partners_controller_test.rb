require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    sign_in users(:tom)
  end

  test "should get index" do
    get :index, event_id: 1
    assert_response :success
  end

  test "should get show" do
    get :show, event_id: 1, id: 1
    assert_response :success
  end
end
