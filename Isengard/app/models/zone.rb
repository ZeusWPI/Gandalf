# == Schema Information
#
# Table name: zones
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  event_id   :integer
#  created_at :datetime
#  updated_at :datetime
#

class Zone < ActiveRecord::Base
  belongs_to :event
end
