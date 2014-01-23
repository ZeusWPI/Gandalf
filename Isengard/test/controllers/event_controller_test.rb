require 'test_helper'

class EventControllerTest < ActionController::TestCase

  def setup
    @controller = EventsController.new
    sign_in users(:tom)
  end

  test "should get show" do
    get :show, id: events(:codenight).id
    assert_response :success
  end

  test "should get create" do
    post :create, id: events(:codenight).id, event: events(:codenight).attributes
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get update" do
    get :update, id: events(:codenight).id, event: events(:codenight).attributes
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

end
