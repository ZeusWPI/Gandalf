require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  include FactoryGirl::Syntax::Methods

  test 'admins can manage registrations from other events' do
    user = users(:adminfelix)
    ability = Ability.new(user)

    r = tickets(:checkin_test_ticket_galabal)
    assert ability.can?(:manage, r)
  end
end
