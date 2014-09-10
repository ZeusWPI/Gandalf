require 'test_helper'

class TicketsControllerTest < ActionController::TestCase
  test "admins can manage registrations from other events" do
    user = users(:adminfelix)
    ability = Ability.new(user)

    r = tickets(:two)
    assert ability.can?(:manage, r)
  end
end
