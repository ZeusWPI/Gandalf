require 'test_helper'

class TicketManipulationTest < ActionDispatch::IntegrationTest
  include FactoryGirl::Syntax::Methods

  self.use_transactional_fixtures = false

  test 'add ticket' do
    sign_in users(:adminfelix)

    visit events_path
    click_on 'All'
    click_on events(:codenight).name
    click_on 'Tickets'
    fill_in 'access_level_name', with: 'Test'

    assert_difference 'Event.find_by_name(events(:codenight).name).access_levels.count', +1 do
      click_button 'Add Ticket'
      assert page.has_content? 'Test'
    end
  end
end
