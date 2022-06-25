# frozen_string_literal: true

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

class IncludedZone < ApplicationRecord
  belongs_to :zone
  belongs_to :access_level
end
