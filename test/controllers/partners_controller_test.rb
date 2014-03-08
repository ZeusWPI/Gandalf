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

  test "should get edit" do
    get :edit, event_id: 1, id: 1
    assert_response :success
  end

  test "should get update" do
    get :update, event_id: 1, id: 1
    assert_response :success
  end

  test "should get destroy" do
    get :destroy, event_id: 1, id: 1
    assert_response :success
  end

  test "should get new" do
    get :new, event_id: 1
    assert_response :success
  end

  test "should get create" do
    get :create, event_id: 1
    assert_response :success
  end

end
