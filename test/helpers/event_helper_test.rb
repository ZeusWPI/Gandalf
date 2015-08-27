require 'test_helper'

class EventHelperTest < ActionView::TestCase
  include FactoryGirl::Syntax::Methods
  include EventHelper

  test 'coloring' do
    assert_equal 'default', \
                 color_for_tickets_left(access_levels(:unlimited))
    assert_equal 'danger', \
                 color_for_tickets_left(access_levels(:limited_0))
    assert_equal 'warning', \
                 color_for_tickets_left(access_levels(:limited_1))
    assert_equal 'default', \
                 color_for_tickets_left(access_levels(:limited_2))
  end
end
