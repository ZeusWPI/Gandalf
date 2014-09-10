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
  has_and_belongs_to_many :access_levels

  def tickets_sold?
    self.sold_tickets != 0
  end
end
