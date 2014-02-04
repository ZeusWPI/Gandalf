require 'test_helper'

class EventTest < ActiveSupport::TestCase
  verify_fixtures Event

  # test "the truth" do
  #   assert true
  # end
  #

  test "enable_toggling_of_registration_status" do
    e = Event.new

    assert e.registration_open
    e.save

    e.toggle_registration_open
    e.save

    assert_not e.registration_open

    e.toggle_registration_open
    e.save

    assert e.registration_open
  end
end
