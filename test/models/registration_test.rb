# frozen_string_literal: true

require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  verify_fixtures Registration

  def setup
    @r1 = Registration.new(
      student_number: "01",
      name: "test",
      email: "test@test.com",
      payment_code: Registration.create_payment_code,
      price: 1,
      paid: 0,
      access_level_id: 1
    )
    @r2 = @r1.dup
    @r2.payment_code = Registration.create_payment_code
  end

  test "student_number should be unique on event basis" do
    @r1.event = events(:codenight)
    @r1.save!
    @r2.event = events(:codenight)
    assert_not @r2.valid?
    assert_not @r2.errors[:student_number].blank?
  end

  test "student_number should work for multiple events" do
    @r1.event = events(:codenight)
    @r1.save!
    @r2.event = events(:galabal)
    assert @r2.save
  end

  test "student_number should be present on members-only tickets" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:members_only)
    assert_not @r1.save
  end

  test "student_number should be present on enrolled-only tickets" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:enrolled_only)
    assert_not @r1.save
  end

  test "student_number should be present on students-only tickets" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:students_only)
    assert_not @r1.save
  end

  test "student_number can be blank on tickets available for everyone" do
    @r1.student_number = ""
    @r1.access_level = access_levels(:unlimited)
    assert @r1.save
  end

  def teardown
    @r1.destroy!
    @r2.destroy!
  end
end

# == Schema Information
#
# Table name: registrations
#
#  id              :integer          not null, primary key
#  barcode         :string(255)
#  barcode_data    :string(255)
#  checked_in_at   :datetime
#  comment         :text(65535)
#  email           :string(255)
#  name            :string(255)
#  paid            :integer
#  payment_code    :string(255)
#  price           :integer
#  student_number  :string(255)
#  token           :string(255)      not null
#  created_at      :datetime
#  updated_at      :datetime
#  access_level_id :integer          not null
#  event_id        :integer
#
# Indexes
#
#  index_registrations_on_access_level_id  (access_level_id)
#  index_registrations_on_event_id         (event_id)
#  index_registrations_on_payment_code     (payment_code) UNIQUE
#  index_registrations_on_token            (token)
#
# Foreign Keys
#
#  fk_rails_...  (access_level_id => access_levels.id)
#  fk_rails_...  (event_id => events.id) ON DELETE => cascade
#
