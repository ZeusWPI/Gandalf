# frozen_string_literal: true

require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper
  include Devise::Test::ControllerHelpers
  verify_fixtures Partner

  test "should get index" do
    sign_in users(:tom)
    get :index, params: { event_id: 1 }
    assert_response :success
  end

  test "should get show for authenticated partners" do
    sign_in partners(:KBC)
    get :show, params: { event_id: 1, id: 1 }
    assert_response :success
  end

  test "should not get show for not authenticated partners" do
    get :show, params: { event_id: 1, id: 1 }
    assert_response :redirect
  end

  test "should not get show for other partners" do
    sign_in partners(:KBC)
    get :show, params: { event_id: 1, id: 2 }
    assert_response :redirect
  end

  test "should not get show for other events" do
    sign_in partners(:KBC)
    get :show, params: { event_id: 2, id: 1 }
    assert_response :redirect
  end

  test "should confirm" do
    sign_in partners(:KBC)
    get :show, params: { event_id: 1, id: 1 }
    assert_response :success
  end

  test "should not confirm for other partners" do
    sign_in partners(:KBC)
    post :confirm, params: { event_id: 1, id: 2 }
    assert_response :redirect
  end

  test "should not confirm for other events" do
    sign_in partners(:KBC)
    post :confirm, params: { event_id: 2, id: partners(:KBC).id }
    assert_response :redirect
  end

  test "should show already confirmed on already confirmed" do
    p = partners(:KBC)
    p.update!(confirmed: true)

    sign_in(p)

    get :show, params: { event_id: 1, id: 1 }

    assert_select "a", text: "You have already registered for this event."
  end

  test "should not allow another registration on confirm when already confirmed" do
    assert_difference "Event.find_by(name: events(:codenight).name).registrations.count", +0 do
      p = partners(:KBC)
      p.update!(confirmed: true)

      sign_in(p)

      post :confirm, xhr: true, params: { event_id: 1, id: 1 }
    end
  end

  test "should send registration mail on confirm" do
    sign_in partners(:KBC)
    post :confirm, xhr: true, params: { event_id: 1, id: 1 }
    assert_enqueued_emails 1
  end

  test "should add registration on confirm" do
    assert_difference "Event.find_by(name: events(:codenight).name).registrations.count", +1 do
      sign_in partners(:KBC)
      post :confirm, xhr: true, params: { event_id: 1, id: 1 }
    end
  end

  test "should confirm correct access level for correct event" do
    p = partners(:KBC)
    assert_difference "Event.find_by(name: events(:codenight).name).registrations.count", +1 do
      sign_in p
      post :confirm, xhr: true, params: { event_id: 1, id: 1 }
    end

    # Get latest registration here
    r = Registration.find_by name: "KBC"
    assert r.name = p.name
    assert r.email = p.email
    assert r.event_id = p.event_id
    assert r.price = p.access_level.price
  end
end
