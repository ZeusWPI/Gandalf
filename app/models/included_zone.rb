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

class IncludedZone < ApplicationRecord
  belongs_to :zone
  belongs_to :access_level
end
