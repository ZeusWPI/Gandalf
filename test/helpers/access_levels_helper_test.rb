# frozen_string_literal: true

require 'test_helper'

class AccessLevelsHelperTest < ActionView::TestCase
  test "should show correct hidden toggle" do
    al = access_levels(:one)
    assert_includes visibility_icon(al), 'Hide'

    al.hidden = true
    assert_includes visibility_icon(al), 'Show'
  end
end
