# == Schema Information
#
# Table name: accesses
#
#  id              :integer          not null, primary key
#  zone_id         :integer
#  period_id       :integer
#  registration_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Access < ActiveRecord::Base
  belongs_to :access_level
  belongs_to :period
  belongs_to :registration
end
