require 'mollie/api/client'

class PaymentWebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:mollie]

  def mollie
    mollie = Mollie::API::Client.new(Rails.application.secrets.mollie_api_key)
    payment_id = params[:id]

    payment = mollie.payments.get payment_id
    registration = Registration.find_by_payment_id payment_id

    if payment.paid?
      registration.paid = payment.amount
      RegistrationMailer.ticket(registration).deliver_now
      registration.save!
    elsif ['cancelled', 'expired', 'failed'].include? payment.status
      RegistrationMailer.payment_failed(registration, registration.event).deliver_now

      registration.destroy!
    end
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
