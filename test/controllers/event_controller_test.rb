require 'test_helper'

class EventControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  include FactoryGirl::Syntax::Methods

  def setup
    stub_request(:get, 'http://fkgent.be/api_isengard_v2.php')
      .with(query: hash_including(u: 'tnnaesse'))
      .to_return(body: '{"data":[{"internalName":"zeus","displayName":"Zeus WPI"},{"internalName":"zeus2","displayName":"Zeus WPI2"}],"controle":"78b385b6d773b180deddee6d5f9819771d6f75031c3ae9ea84810fa6869e1547"}')

    @controller = EventsController.new
    sign_in create(:admin)
  end

  test 'should get show' do
    get :show, id: create(:event)
    assert_response :success
  end

  test 'should get create' do
    c = create(:club)
    post :create, event: attributes_for(:event).merge(club_id: c.id)

    assert_response :redirect
  end

  test 'should get new' do
    get :new
    assert_response :success
  end

  test 'should get update' do
    event = create(:event)
    get :update, id: event, event: event.attributes

    assert_response :success
  end

  test 'should get index' do
    create(:event)

    get :index
    assert_response :success
  end

  test 'should get scan' do
    get :scan, id: create(:event)
    assert_response :success
  end

  test 'toggle registration open' do
    e = create(:event)

    user = build(:user, username: 'tnnaesse')
    ability = Ability.new(user)

    assert e.registration_open
    assert ability.can?(:register, e)

    post :toggle_registration_open, id: e.id
    assert_not e.reload.registration_open
    assert_not ability.can?(:register, e)

    post :toggle_registration_open, id: e.id
    assert e.reload.registration_open
    assert ability.can?(:register, e)
  end

  test 'dont find registrations from other event' do
    e = build(:event)

    post :scan_barcode, id: events(:codenight).id, code: '2222222222222'
    assert_response :success
    assert_nil @ticket
  end

  test 'dont check in unpaid tickets' do
    sign_out users(:tom)
    sign_in users(:maarten)
    post :scan_barcode, id: events(:galabal).id, code: '2222222222222'
    assert_response :success
    assert(flash[:warning].include? 'has not been paid')
  end

  # Scan tests
  test 'validate correct barcode' do
    post :scan_barcode, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:success].include? 'Person has been scanned')
  end

  test 'validate correct name' do
    post :scan_name, id: events(:codenight).id, name: 'Checking Test Codenight'
    assert_response :success
    assert(flash[:success].include? 'Person has been scanned')
  end

  test 'dont check in twice' do
    post :scan_barcode, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:success].include? 'Person has been scanned')
    post :scan_barcode, id: events(:codenight).id, code: '1234567891231'
    assert_response :success
    assert(flash[:warning].include? 'Person already checked in')
  end

  test 'scan page should include check digit' do
    post :scan_barcode, id: events(:codenight), code: '1234567891231'
    assert_response :success
    # expect at least one <th> with value "Barcode:" and the full code with checkdigit
    assert_select 'tr' do
      assert_select 'th', 'Barcode:'
      assert_select 'td', '1234567891231'
    end
  end

  # test "member tickets should not be shown for wrong user" do
  #   sign_out users(:tom)
  #   get :show, id: events(:codenight).id
  #   assert_response :success

  #   assert assigns(:event)
  #   assert_select "#ticket_access_levels" do
  #     assert_select "option", count: 1, text: "Lid"
  #     assert_select "option", count: 1, text: "Unlimited"
  #     assert_select "option", count: 0, text: "Member Only"
  #   end
  # end

  # test "member tickets should be shown for enrolled user" do
  #   sign_out users(:tom)
  #   sign_in users(:matthias)
  #   assert users(:matthias).enrolled_clubs.include? clubs(:zeus)
  #   get :show, id: events(:codenight).id

  #   assert_response :success

  #   assert_select "#ticket_access_levels" do
  #     assert_select "option", count: 1, text: "Lid"
  #     assert_select "option", count: 1, text: "Unlimited"
  #     assert_select "option", count: 1, text: "Member"
  #   end

  # end

  # test "ticket form hidden when only member or hidden tickets available" do
  #   get :show, id: events(:twaalfurenloop).id
  #   assert_select "#basic-registration-form", false, "Should not contain registration form"
  # end

  # test "registration form shown when a ticket is available" do
  #   get :show, id: events(:codenight).id
  #   assert_select "#basic-registration-form", true, "Should contain registration form"
  # end

  # test "do statistics" do
  #   date = "#{registrations(:one).created_at.to_date}"
  #   get :statistics, { id: events(:codenight) }
  #   assert_response :success
  #   assert assigns(:data) == [
  #     { name: "Lid",       data: { date => 1 } },
  #     { name: "Limited0",  data: { date => 3 } },
  #     { name: "Limited1",  data: { date => 3 } },
  #     { name: "Limited2",  data: { date => 3 } },
  #     { name: "Member",    data: { date => 0 } },
  #     { name: "Unlimited", data: { date => 0 } }
  #   ], "Got #{assigns(:data).inspect} on #{date}"
  # end
end
