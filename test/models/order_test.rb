# == Schema Information
#
# Table name: orders
#
#  id           :integer          not null, primary key
#  status       :string(255)      default("initial")
#  name         :string(255)
#  email        :string(255)
#  gsm          :string(255)
#  ticket_id    :integer
#  event_id     :integer
#  paid         :integer
#  price        :integer
#  created_at   :datetime
#  updated_at   :datetime
#  payment_code :string(255)
#

require 'test_helper'

class OrderTest < ActiveSupport::TestCase
  verify_fixtures Order

  test "active? returns correct status" do
    order = orders(:one)
    assert !order.active?
    order.status = 'active'
    assert order.active?
  end
end
