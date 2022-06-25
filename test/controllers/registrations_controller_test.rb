# frozen_string_literal: true

require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper
  include Devise::Test::ControllerHelpers

  def setup
    stub_request(:get, "http://fkgent.be/api_isengard_v2.php")
      .with(query: hash_including(u: "")).to_return(body: 'FAIL')

    sign_in users(:tom)
  end

  test "uploading partially failed registrations" do
    # Quick check for the used fixture
    three = registrations(:three)
    assert_equal 0, three.paid

    # Posting the csv file
    assert_enqueued_emails(1) do
      post :upload, params: {
        event_id: 1,
        separator: ';',
        amount_column: 'Amount',
        csv_file: fixture_file_upload('unsuccesful_registration_payments.csv')
      }
    end

    # Check if the correct rows failed.
    assert_not_nil assigns(:csvfails)
    assigns(:csvfails).each do |csvfail|
      assert_match(/FAIL.*/, csvfail.to_s)
    end

    # Check if the flash is correct
    assert_equal 'Updated 1 payment successfully.', flash[:success]
    assert_equal 'The rows listed below contained an invalid code, please fix them by hand.', flash[:error]

    # Check if the success registration got changed.
    assert_equal 0.01, three.reload.paid
  end

  test "resend sends an email" do
    assert_enqueued_email_with(RegistrationMailer, :ticket, args: [registrations(:one)]) do
      get :resend, xhr: true, params: { event_id: events(:codenight), id: registrations(:one).id }
    end
  end

  test "resend sends payment email when !is_paid" do
    assert_enqueued_email_with(RegistrationMailer, :confirm_registration, args: [registrations(:three)]) do
      get :resend, xhr: true, params: { event_id: events(:codenight), id: registrations(:three).id }
    end
  end

  test "resend sends ticket email when is_paid" do
    assert_enqueued_email_with(RegistrationMailer, :ticket, args: [registrations(:one)]) do
      get :resend, xhr: true, params: { event_id: events(:codenight), id: registrations(:one).id }
    end
  end

  test "manual full paying works" do
    three = registrations(:three)
    four = registrations(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    [three, four].each do |registration|
      assert_enqueued_email_with(RegistrationMailer, :ticket, args: [registration]) do
        put :update, xhr: true, params: {
          event_id: registration.event.id,
          id: registration.id,
          registration: { to_pay: 0 }
        }
      end
      assert_equal registration.price, registration.reload.paid
    end
  end

  test "manual partial paying works" do
    three = registrations(:three)
    four = registrations(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    to_pay = 0.01

    [three, four].each do |registration|
      assert_enqueued_email_with(RegistrationMailer, :confirm_registration, args: [registration]) do
        put :update, xhr: true, params: {
          event_id: registration.event.id,
          id: registration.id,
          registration: { to_pay: to_pay }
        }
      end
      assert registration.price > registration.reload.paid
    end
  end

  test "manual overpaying works" do
    three = registrations(:three)
    four = registrations(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    to_pay = -5

    [three, four].each do |registration|
      assert_enqueued_email_with(RegistrationMailer, :ticket, args: [registration]) do
        assert_enqueued_email_with(RegistrationMailer, :notify_overpayment, args: [registration]) do
          put :update, xhr: true, params: {
            event_id: registration.event.id,
            id: registration.id,
            registration: { to_pay: to_pay }
          }
        end
      end
      assert registration.price < registration.reload.paid
    end
  end

  test "manual not changing mails nor changes the code" do
    three = registrations(:three)
    four = registrations(:four)

    assert_equal 0, three.paid
    assert_equal 0.05, four.paid

    [three, four].each do |registration|
      paid, code = registration.paid, registration.payment_code
      assert_no_difference "ActionMailer::Base.deliveries.size" do
        put :update, xhr: true, params: {
          event_id: registration.event.id,
          id: registration.id,
          registration: { to_pay: registration.to_pay }
        }
      end
      assert_equal paid, registration.reload.paid
      assert_equal code, registration.reload.payment_code
    end
  end

  test "basic registration" do
    # setting up data
    galabal = events(:galabal)
    posthash = {
      event_id: galabal.id,
      registration: {
        access_levels: 2,
        email: "a@b.com",
        name: "Ab Cd",
        student_number: 123,
        comment: ""
      }
    }

    assert_difference "Registration.count", +1 do
      assert_enqueued_emails(1) do
        post :basic, params: posthash 
      end
    end
  end

  test "admins can manage registrations from other events" do
    user = users(:adminfelix)
    ability = Ability.new(user)

    r = registrations(:two)
    assert ability.can?(:manage, r)
  end
end
