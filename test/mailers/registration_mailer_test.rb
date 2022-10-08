# frozen_string_literal: true

require 'test_helper'

class RegistrationMailerTest < ActionMailer::TestCase
  include ActionMailer::TestHelper

  test "signature of registration emails can be branded" do
    e = events(:codenight)
    e.signature = "Een signatuur"
    e.save!

    assert_emails(1) do
      RegistrationMailer.confirm_registration(registrations(:three)).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Registration for/, email.subject)
    # Both html and plaintext mail should contain the signature
    assert_match(/Een signatuur/, email.parts.first.body.to_s)
    assert_match(/Een signatuur/, email.parts.second.body.to_s)
  end

  test "signature of ticket emails can be branded" do
    e = events(:codenight)
    e.signature = "Een signatuur"
    e.save!

    assert_emails(1) do
      RegistrationMailer.ticket(registrations(:one)).deliver_now
    end

    email = ActionMailer::Base.deliveries.last
    assert_match(/Ticket for/, email.subject)
    # We only have a html part (and 2 png parts) here
    assert_match(/Een signatuur/, email.parts.first.body.to_s)
  end
end
