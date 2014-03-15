require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
  end

  test "should get index" do
    sign_in users(:tom)
    get :index, event_id: 1
    assert_response :success
  end

  test "should get show" do
    sign_in partners(:KBC)
    get :show, event_id: 1, id: 1
    assert_response :success
  end
end
