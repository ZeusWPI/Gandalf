# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  checked_in_at   :datetime
#  event_id        :integer
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

  test "student_number should be unique on event basis for member-only tickets" do
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
