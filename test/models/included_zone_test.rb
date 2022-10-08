# frozen_string_literal: true
require 'test_helper'

class IncludedZoneTest < ActiveSupport::TestCase
  verify_fixtures IncludedZone

  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: included_zones
#
#  id              :integer          not null, primary key
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#  zone_id         :integer
#
# Indexes
#
#  index_included_zones_on_access_level_id  (access_level_id)
#  index_included_zones_on_zone_id          (zone_id)
#
