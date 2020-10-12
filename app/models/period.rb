# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  starts     :datetime
#  ends       :datetime
#  name       :string
#  created_at :datetime
#  updated_at :datetime
#  event_id   :integer
#

class Period < ApplicationRecord
  belongs_to :event, optional: true
  has_many :accesses
end
