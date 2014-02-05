require 'test_helper'

class EventControllerTest < ActionController::TestCase
  include Devise::TestHelpers

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

  test "should get scan" do
    get :scan, id: events(:codenight).id
    assert_response :success
  end

  test "validate correct barcode" do
    post :check_in, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:success].include? "Person has been scanned")
  end

  test "dont check in twice" do
    post :check_in, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:success].include? "Person has been scanned")
    post :check_in, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:warning].include? "Person already checked in")
  end

  test "dont find registrations from other event" do
    post :check_in, id: events(:codenight).id, code: '2222222222222'
    assert_response :success
    assert_nil(@registration)
  end

  test "dont check in unpaid tickets" do
    post :check_in, id: events(:galabal).id, code: '2222222222222'
    assert_response :success
    assert(flash[:warning].include? "Person has not paid yet!")
  end

  test "scan page should include check digit" do
    post :check_in, id: events(:codenight), code: '1234567891231'
    assert_response :success
    # expect at least one <th> with value "Barcode:" and the full code with checkdigit
    assert_select "tr" do
      assert_select "th", "Barcode:"
      assert_select "td", "1234567891231"
    end
  end
end
