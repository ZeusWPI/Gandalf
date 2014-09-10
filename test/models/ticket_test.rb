# == Schema Information
#
# Table name: tickets
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  gsm             :string(255)
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
#

require 'test_helper'

class TicketTest < ActiveSupport::TestCase
  def setup
    @r1 = Ticket.new(student_number: "01", name: "test", email: "test@test.com")
    @r2 = @r1.dup
  end

  test "student_number should be unique on event basis" do
    @r1.event = events(:codenight)
    @r1.save!
    @r2.event = events(:codenight)
    assert !@r2.valid?
    assert !@r2.errors[:student_number].blank?
  end

  test "student_number should work for multiple events" do
    @r1.event = events(:codenight)
    @r1.save!
    @r2.event = events(:galabal)
    assert @r2.save
  end

  test "student_number should be present on member_only tickets" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:member_only)
    assert !@r1.save
  end

  test "student_number can be blank on non-member_only tickets" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:unlimited)
    assert @r1.save
  end

  def teardown
    @r1.destroy
    @r2.destroy
  end
end
