# frozen_string_literal: true

class RegistrationMailer < ApplicationMailer
  helper ApplicationHelper

  def confirm_registration(registration)
    @registration = registration

    attachments.inline['epc.png'] = GenerateEmailEpcQr.new(@registration.epc_data).call

    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

  def ticket(registration)
    @registration = registration

    barcodes = GenerateEmailBarcodes.new(@registration.barcode_data).call

    attachments.inline['barcode.png'] = barcodes.first
    attachments.inline['barcode-tilted.png'] = barcodes.second

    mail to: "#{registration.name} <#{registration.email}>", subject: "Ticket for #{registration.event.name}"
  end

  def notify_overpayment(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Overpayment for #{registration.event.name}"
  end
end
