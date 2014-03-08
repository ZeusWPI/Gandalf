# == Schema Information
#
# Table name: reservations
#
#  id              :integer          not null, primary key
#  partner_id      :integer
#  access_level_id :integer
#  price           :integer
#  paid            :integer
#  count           :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Reservation < ActiveRecord::Base
  belongs_to :partner
  belongs_to :access_level
end
