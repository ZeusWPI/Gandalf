# == Schema Information
#
# Table name: registrations
#
#  id         :integer          not null, primary key
#  barcode    :integer
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#

class Registration < ActiveRecord::Base
  belongs_to :event
end
