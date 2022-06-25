# frozen_string_literal: true

require 'test_helper'

class EventControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def setup
    stub_request(:get, "http://fkgent.be/api_isengard_v2.php")
      .with(query: hash_including(u: 'tnnaesse'))
      .to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    @controller = EventsController.new
    sign_in users(:tom)
  end

  test "should get show" do
    get :show, params: { id: events(:codenight).id }
    assert_response :success
  end

  test "should get create" do
    post :create, params: { id: events(:codenight).id, event: events(:codenight).attributes }
    assert_response :redirect
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get update" do
    get :update, params: { id: events(:codenight).id, event: events(:codenight).attributes }
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get scan" do
    get :scan, params: { id: events(:codenight).id }
    assert_response :success
  end

  test "toggle registration open" do
    e = events(:codenight)

    user = users(:tom)
    ability = Ability.new(user)

    assert e.registration_open
    assert ability.can?(:register, e)

    post :toggle_registration_open, params: { id: e.id }
    assert_not e.reload.registration_open
    assert_not ability.can?(:register, e)

    post :toggle_registration_open, params: { id: e.id }
    assert e.reload.registration_open
    assert ability.can?(:register, e)
  end

  test "validate correct barcode" do
    post :scan_barcode, params: { id: events(:codenight).id, code: '1234567891231' }
    assert_response :success
    assert(flash[:success].include? "Person has been scanned")
  end

  test "validate correct name" do
    post :scan_name, params: { id: events(:codenight).id, name: 'Tom Naessens' }
    assert_response :success
    assert(flash[:success].include? "Person has been scanned")
  end

  test "dont check in twice" do
    post :scan_barcode, params: { id: events(:codenight).id, code: '1234567891231' }
    assert_response :success
    assert(flash[:success].include? "Person has been scanned")
    post :scan_barcode, params: { id: events(:codenight).id, code: '1234567891231' }
    assert_response :success
    assert(flash[:warning].include? "Person already checked in")
  end

  test "show unpaid for checked in unpaid tickets" do
    reg = registrations(:one)
    reg.update!(checked_in_at: Time.now, price: 10)

    post :scan_barcode, params: { id: events(:codenight).id, code: '1234567891231' }
    assert_response :success
    assert_nil(@registration)
    assert(flash[:warning].include? "Person has not paid yet!")
  end

  test "dont find registrations from other event" do
    post :scan_barcode, params: { id: events(:codenight).id, code: '2222222222222' }
    assert_response :success
    assert_nil(@registration)
  end

  test "dont check in unpaid tickets" do
    sign_out users(:tom)
    sign_in users(:maarten)
    post :scan_barcode, params: { id: events(:galabal).id, code: '2222222222222' }
    assert_response :success
    assert(flash[:warning].include? "Person has not paid yet!")
  end

  test "scan page should include check digit" do
    post :scan_barcode, params: { id: events(:codenight), code: '1234567891231' }
    assert_response :success
    # expect at least one <th> with value "Barcode:" and the full code with checkdigit
    assert_select "tr" do
      assert_select "th", "Barcode:"
      assert_select "td", "1234567891231"
    end
  end

  test "member tickets should not be shown for wrong user" do
    sign_out users(:tom)
    get :show, params: { id: events(:codenight).id }
    assert_response :success

    assert assigns(:event)
    assert_select "#registration_access_levels" do
      assert_select "option", count: 1, text: "Lid"
      assert_select "option", count: 1, text: "Unlimited"
      assert_select "option", count: 0, text: "Member Only"
    end
  end

  test "member tickets should be shown for enrolled user" do
    sign_out users(:tom)
    sign_in users(:matthias)
    assert users(:matthias).enrolled_clubs.include? clubs(:zeus)
    get :show, params: { id: events(:codenight).id }

    assert_response :success

    assert_select "#registration_access_levels" do
      assert_select "option", count: 1, text: "Lid"
      assert_select "option", count: 1, text: "Unlimited"
      assert_select "option", count: 1, text: "Member"
    end
  end

  test "registration form hidden when only member or hidden tickets available" do
    get :show, params: { id: events(:twaalfurenloop).id }
    assert_select "#basic-registration-form", false, "Should not contain registration form"
  end

  test "registration form shown when a ticket is available" do
    get :show, params: { id: events(:codenight).id }
    assert_select "#basic-registration-form", true, "Should contain registration form"
  end

  test "do statistics" do
    date = "#{registrations(:one).created_at.utc.to_date}"
    get :statistics, params: { id: 1 }
    assert_response :success
    expected = [
      { name: "Lid",       data: { date => 1 } },
      { name: "Limited0",  data: { date => 3 } },
      { name: "Limited1",  data: { date => 3 } },
      { name: "Limited2",  data: { date => 3 } },
      { name: "Member",    data: { date => 0 } },
      { name: "Unlimited", data: { date => 0 } }
    ]
    expected.zip(assigns(:data)).each do |e, a|
      assert e[:name] == a[:name], "Mismatching names. Expected #{e[:name]} got #{a[:name]}"
      e[:data].keys.each do |k|
        assert (a[:data].has_key? k), "Missing date for #{e[:name]}: #{k}"
        assert e[:data][k] == a[:data][k],
               "Mismatching counts for #{e[:name]} on #{k}: Expected #{e[:data][k]} got #{a[:data][k]}"
      end
    end
  end

  test "registration form for student-only event shown when logged in" do
    sign_in users(:matthias)
    get :show, params: { id: events(:sko).id }
    assert_select "#basic-registration-form", true, "Should contain registration form"
  end

  test "registration form for student-only event hidden when logged out" do
    sign_out users(:matthias)
    get :show, params: { id: events(:twaalfurenloop).id }
    assert_select "#basic-registration-form", false, "Should not contain registration form"
  end
end
