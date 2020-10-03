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

class Zone < ApplicationRecord
  belongs_to :event
  has_many :included_zones, dependent: :destroy
  has_many :access_levels, through: :included_zones

  validates :name, presence: true
end
