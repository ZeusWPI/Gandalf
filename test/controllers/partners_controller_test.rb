require 'test_helper'

class PartnersControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods

  def setup
  end

  test 'should get index' do
    sign_in users(:tom)
    get :index, event_id: events(:codenight)
    assert_response :success
  end

  test 'should get show for authenticated partners' do
    sign_in partners(:KBC)
    get :show, event_id: events(:codenight), id: partners(:KBC)
    assert_response :success
  end

  test 'should not get show for not authenticated partners' do
    get :show, event_id: events(:codenight), id: partners(:KBC)
    assert_response :redirect
  end

  test 'should not get show for other partners' do
    sign_in partners(:KBC)
    get :show, event_id: events(:codenight), id: partners(:Zeus)
    assert_response :redirect
  end

  test 'should not get show for other events' do
    sign_in partners(:KBC)
    get :show, event_id: events(:galabal), id: partners(:KBC)
    assert_response :redirect
  end

  test 'should confirm' do
    sign_in partners(:KBC)
    get :show, event_id: events(:codenight), id: partners(:KBC)
    assert_response :success
  end

  test 'should not confirm for other partners' do
    sign_in partners(:KBC)
    post :confirm, event_id: events(:codenight), id: partners(:Zeus)
    assert_response :redirect
  end

  test 'should not confirm for other events' do
    sign_in partners(:KBC)
    post :confirm, event_id: events(:galabal), id: partners(:KBC)
    assert_response :redirect
  end

  test 'should show already confirmed on already confirmed' do
    p = partners(:KBC)
    p.confirmed = true
    p.save

    sign_in(p)

    get :show, event_id: events(:codenight), id: partners(:KBC)

    assert_select 'a', text: 'You have already registered for this event.'
  end

  test 'should not allow another registration on confirm when already confirmed' do
    assert_difference 'Event.find_by_name(events(:codenight).name).tickets.count', +0 do
      p = partners(:KBC)
      p.confirmed = true
      p.save

      sign_in(p)

      xhr :post, :confirm, event_id: events(:codenight), id: partners(:KBC)
    end
  end

  test 'should send registration mail on confirm' do
    assert_difference 'ActionMailer::Base.deliveries.size', +1 do
      sign_in partners(:KBC)
      xhr :post, :confirm, event_id: events(:codenight), id: partners(:KBC)
    end
  end

  test 'should add registration on confirm' do
    assert_difference 'Event.find_by_name(events(:codenight).name).tickets.count', +1 do
      sign_in partners(:KBC)
      xhr :post, :confirm, event_id: events(:codenight), id: partners(:KBC)
    end
  end

  test 'should confirm correct access level for correct event' do
    p = partners(:KBC)
    assert_difference 'Event.find_by_name(events(:codenight).name).tickets.count', +1 do
      sign_in p
      xhr :post, :confirm, event_id: events(:codenight), id: partners(:KBC)
    end

    # Get latest registration here
    r = Ticket.find_by_name 'KBC'
    assert r.name = p.name
    assert r.email = p.email
    assert r.event = p.event
    assert r.order.price = p.access_level.price
  end
end
