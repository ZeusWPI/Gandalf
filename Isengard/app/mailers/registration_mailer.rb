class RegistrationMailer < ActionMailer::Base
  default from: "noreply@event.fkgent.be"

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

  def ticket(registration)
    @registration = registration

    require 'barby/barcode/ean_13'
    require 'barby/outputter/rmagick_outputter'
    barcode = Barby::EAN13.new(registration.barcode)
    attachments.inline['barcode.png'] = Barby::RmagickOutputter.new(barcode).to_png

    mail to: "#{registration.name} <#{registration.email}>", subject: "Ticket for #{registration.event.name}"
  end

end
