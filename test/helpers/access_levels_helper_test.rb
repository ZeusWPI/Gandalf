require 'test_helper'

class AccessLevelsHelperTest < ActionView::TestCase

  test "should show correct hidden toggle" do
    al = access_levels(:one)
    assert visibility_icon(al).include? 'Hide'

    al.hidden = true
    assert visibility_icon(al).include? 'Show'
  end
end
