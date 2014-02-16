require 'test_helper'

class RegistrationTest < ActiveSupport::TestCase
  verify_fixtures Registration

  def setup
    @r1 = Registration.new(student_number: "01", name: "test", email: "test@test.com", payment_code: Registration.create_payment_code, price: 1, paid: 0)
    @r2 = @r1.dup
    @r2.payment_code = Registration.create_payment_code
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
    @r1.access_levels << access_levels(:member_only)
    assert !@r1.save
  end

  test "student_number can be blank on non-member_only tickets" do
    @r1.student_number = ""
    @r1.access_levels << access_levels(:unlimited)
    assert @r1.save
  end

  def teardown
    @r1.destroy
    @r2.destroy
  end

end
