# == Schema Information
#
# Table name: periods
#
#  id         :integer          not null, primary key
#  starts     :datetime
#  ends       :datetime
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Period < ActiveRecord::Base
  belongs_to :event
  has_many :accesses
end
