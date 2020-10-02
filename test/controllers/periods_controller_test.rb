require 'test_helper'

class PeriodsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers

  test "creation forces login" do

    post :create, {
      event_id: 2,
      period: {
        name: 'Periods 1',
        starts: '2013-09-17 20:09:09',
        ends: '2013-09-17 20:09:09'
      }
    }, format: 'js'

    assert_redirected_to new_user_session_path
  end

  test "creation requires event crud" do
    sign_in users(:tom)

    post :create, {
      event_id: 2,
      period: {
        name: 'Periods 2',
        starts: '2013-09-17 20:09:09',
        ends: '2013-09-17 20:09:09'
      }
    }, format: 'js'

    assert_redirected_to root_path
    assert_not flash[:error].empty?
  end

  test "creation works" do
    sign_in users(:tom)

    post :create, {
      format: :js,
      event_id: 1,
      period: {
        name: 'Periods 3',
        starts: '2013-09-17 20:09:09',
        ends: '2013-09-17 20:09:09'
      }
    }

    assert_response :success
  end
end
