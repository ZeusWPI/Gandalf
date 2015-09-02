require 'test_helper'

class AccessLevelsHelperTest < ActionView::TestCase
  include FactoryGirl::Syntax::Methods

  test 'should show correct hidden toggle' do
    al = build(:access_level)
    assert visibility_icon(al).include? 'Hide'

    al.hidden = true
    assert visibility_icon(al).include? 'Show'
  end
end
