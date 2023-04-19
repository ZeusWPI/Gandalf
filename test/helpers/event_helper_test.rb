# frozen_string_literal: true

require 'test_helper'

class EventHelperTest < ActionView::TestCase
  include EventHelper

  test "coloring" do
    assert_equal "default",
                 color_for_tickets_left(access_levels(:unlimited))
    assert_equal "danger",
                 color_for_tickets_left(access_levels(:limited0))
    assert_equal "warning",
                 color_for_tickets_left(access_levels(:limited1))
    assert_equal "default",
                 color_for_tickets_left(access_levels(:limited2))
  end
end
