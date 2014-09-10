# == Schema Information
#
# Table name: promos
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  code       :string(255)
#  limit      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Promo < ActiveRecord::Base
  belongs_to :event
  has_many :access_levels, through: :promo_access_levels_join_table
end
