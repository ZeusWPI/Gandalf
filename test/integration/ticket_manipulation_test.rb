require 'test_helper'

class TicketManipulationTest < ActionDispatch::IntegrationTest

  self.use_transactional_fixtures = false

  test "add ticket" do
    sign_in users(:adminfelix)

    visit "/events"
    click_on events(:codenight).name
    click_on "Tickets"
    fill_in 'access_level_name', with: "Test"

    assert_difference "events(:codenight).reload.access_levels.count", 1 do
      click_button "Add Ticket"
      visit current_path
      assert page.has_content? "Test"
    end

  end
end
