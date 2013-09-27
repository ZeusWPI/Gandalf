# == Schema Information
#
# Table name: zone_accesses
#
#  id              :integer          not null, primary key
#  zone_id         :integer
#  period_id       :integer
#  registration_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class ZoneAccess < ActiveRecord::Base
  belongs_to :zone
  belongs_to :period
  belongs_to :registration
end
