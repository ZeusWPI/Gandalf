# frozen_string_literal: true

class Zone < ApplicationRecord
  belongs_to :event
  has_many :included_zones, dependent: :destroy
  has_many :access_levels, through: :included_zones

  validates :name, presence: true
end

# == Schema Information
#
# Table name: zones
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#
# Indexes
#
#  index_zones_on_event_id           (event_id)
#  index_zones_on_name_and_event_id  (name,event_id) UNIQUE
#
