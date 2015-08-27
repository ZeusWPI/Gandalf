# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  status       :string           default("initial")
#  name         :string
#  email        :string
#  gsm          :string
#  ticket_id    :integer
#  event_id     :integer
#  paid         :integer
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  payment_code :string
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  test 'active? returns correct status' do
    order = orders(:one)
    assert !order.active?
    order.status = 'active'
    assert order.active?
  end
end
