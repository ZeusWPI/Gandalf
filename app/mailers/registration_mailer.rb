class RegistrationMailer < ActionMailer::Base

  helper ApplicationHelper

  default from: "noreply@event.fkgent.be"

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

  def ticket(registration)
    @registration = registration

    barcode = Barcodes.create('EAN13', data: registration.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    attachments.inline['barcode.png'] = Barcodes::Renderer::Image.new(barcode).render

    mail to: "#{registration.name} <#{registration.email}>", subject: "Ticket for #{registration.event.name}"
  end

  def notify_overpayment(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Overpayment for #{registration.event.name}"
  end

end
