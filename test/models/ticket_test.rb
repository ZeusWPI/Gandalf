# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  checked_in_at   :datetime
#  order_id        :integer
#  student_number  :string(255)
#  comment         :text
#  barcode         :string(255)
#  barcode_data    :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer
#  status          :string(255)      default("initial")
#

require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  verify_fixtures Ticket

  def setup
  end

  test "multiple non member tickets for the same access level should not be able to have the same name" do
    active_order = orders(:ticket_validation_add_ticket_info)

    t1 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_open)
    t2 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_open)

    assert t1.save
    assert !t2.save
  end

  test "multiple non member tickets for different access levels should be able to have the same name" do
    active_order = orders(:ticket_validation_add_ticket_info)

    t1 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_open)
    t2 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_member)

    assert t1.save
    assert t2.save
  end

  test "info should be unique on event basis for member-only tickets" do
    active_order = orders(:ticket_validation_add_ticket_info)

    t1 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_member)
    t2 = active_order.tickets.new name: "Zelfde", email: "Zelfde", access_level: access_levels(:ticket_validation_member)

    assert t1.save
    assert !t2.save
  end

  test "a member should not be able to order another member only ticket in another order in the same event" do
    add_ticket_info_order = orders(:ticket_validation_add_ticket_info)

    t = add_ticket_info_order.tickets.new name: "Ticket validation active member only", email: "ticket@validation.activememberonly", access_level: access_levels(:ticket_validation_member)

    assert !t.save
  end

  test "same student_number should work for multiple events" do
  end

  test "student_number should be present on member_only tickets" do
  end

  test "student_number can be blank on non-member_only tickets" do
  end

  def teardown
  end
end
