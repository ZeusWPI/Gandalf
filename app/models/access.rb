# == Schema Information
#
# Table name: accesses
#
#  id              :integer          not null, primary key
#  period_id       :integer
#  registration_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#

class Access < ApplicationRecord
  belongs_to :access_level
  belongs_to :period, optional: true
  belongs_to :registration
end
