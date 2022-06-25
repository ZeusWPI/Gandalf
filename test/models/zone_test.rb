# frozen_string_literal: true

# == Schema Information
#
# Table name: zones
#
#  id         :integer          not null, primary key
#  name       :string
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  verify_fixtures Zone

  # test "the truth" do
  #   assert true
  # end
end
