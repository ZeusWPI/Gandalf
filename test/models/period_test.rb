# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  starts     :datetime
#  ends       :datetime
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#

require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
  verify_fixtures Period

  # test "the truth" do
  #   assert true
  # end
end
