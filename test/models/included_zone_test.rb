# frozen_string_literal: true

# == Schema Information
#
# Table name: included_zones
#
#  id              :integer          not null, primary key
#  zone_id         :integer
#  access_level_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'test_helper'

class IncludedZoneTest < ActiveSupport::TestCase
  verify_fixtures IncludedZone

  # test "the truth" do
  #   assert true
  # end
end
