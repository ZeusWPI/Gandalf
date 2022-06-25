# frozen_string_literal: true

# == Schema Information
#
# Table name: zones
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#
# Indexes
#
#  index_zones_on_event_id           (event_id)
#  index_zones_on_name_and_event_id  (name,event_id) UNIQUE
#

require 'test_helper'

class ZoneTest < ActiveSupport::TestCase
  verify_fixtures Zone

  # test "the truth" do
  #   assert true
  # end
end
