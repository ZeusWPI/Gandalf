require 'mollie/api/client'

class PaymentWebhookController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => [:mollie]

  def mollie
    mollie = Mollie::API::Client.new(Rails.application.secrets.mollie_api_key)
    payment_id = params[:id]

    payment = mollie.payments.get payment_id
    registrations = Registration.where(payment_id: payment_id)

    if payment.paid?
      registrations.each do |reg|
        reg.paid = payment.amount / reg.number_of_tickets
        RegistrationMailer.ticket(reg).deliver_now
        reg.save!
      end
    elsif ['cancelled', 'expired', 'failed'].include? payment.status
      RegistrationMailer.payment_failed(registrations.first, registrations.first.event).deliver_now

      registrations.each do |reg|
        reg.destroy!
      end
    end
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end
end
