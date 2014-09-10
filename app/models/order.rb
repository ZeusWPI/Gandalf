# == Schema Information
#
# Table name: orders
#
#  id         :integer          not null, primary key
#  status     :string(255)
#  name       :string(255)
#  email      :string(255)
#  gsm        :string(255)
#  ticket_id  :integer
#  event_id   :integer
#  paid       :integer
#  price      :integer
#  created_at :datetime
#  updated_at :datetime
#

class Order < ActiveRecord::Base
  belongs_to :event
end
