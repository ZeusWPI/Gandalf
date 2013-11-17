class RegistrationMailer < ActionMailer::Base
  default from: "noreply@event.fkgent.be"

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

  def ticket(registration)
    @registration = registration

    barcode = Barcodes.create('EAN13', data: registration.barcode)
    attachments.inline['barcode.pdf'] = Barcodes::Renderer::Image.new(barcode).render

    mail to: "#{registration.name} <#{registration.email}>", subject: "Ticket for #{registration.event.name}"
  end

end
