require 'test_helper'

class TicketManipulationTest < ActionDispatch::IntegrationTest

  self.use_transactional_fixtures = false

  test "add ticket" do
    sign_in users(:adminfelix)

    visit events_path
    click_on events(:codenight).name
    click_on "Tickets"
    fill_in 'access_level_name', with: "Test"

    initial_size = events(:codenight).access_levels.count

    click_button "Add Ticket"
    visit current_path
    assert page.has_content? "Test"

    # TODO: figure out why this sometimes is submitted twice
    assert Event.find_by_name(events(:codenight).name).access_levels.count > initial_size

  end
end
