# frozen_string_literal: true

# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  ends       :datetime
#  name       :string
#  starts     :datetime
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#
# Indexes
#
#  index_periods_on_event_id  (event_id)
#

require 'test_helper'

class PeriodTest < ActiveSupport::TestCase
  verify_fixtures Period

  # test "the truth" do
  #   assert true
  # end
end
