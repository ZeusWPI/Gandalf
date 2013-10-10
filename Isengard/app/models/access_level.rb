# == Schema Information
#
# Table name: access_levels
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class AccessLevel < ActiveRecord::Base
  belongs_to :event
  has_many :included_zones, dependent: :destroy
  has_many :zones, through: :included_zones

  def set_zones_by_ids zones
    self.zones = self.event.zones.find zones
    self.save
  end

end
