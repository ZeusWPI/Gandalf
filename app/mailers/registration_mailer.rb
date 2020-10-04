require 'barby'
require 'barby/barcode/ean_13'
require 'barby/outputter/png_outputter'

class RegistrationMailer < ActionMailer::Base

  helper ApplicationHelper

  default from: "noreply@event.fkgent.be"

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Registration for #{registration.event.name}"
  end

  def ticket(registration)
    @registration = registration

    barcode = Barby::EAN13.new(registration.barcode_data)
    pngoutputter = Barby::PngOutputter.new(barcode)
    pngoutputter.xdim = 2
    pngoutputter.ydim = 1
    image = pngoutputter.to_png
    attachments.inline['barcode.png'] = image

    tilted_image = Magick::Image.from_blob(image).first.rotate!(-90).to_blob
    attachments.inline['barcode-tilted.png'] = tilted_image

    mail to: "#{registration.name} <#{registration.email}>", subject: "Ticket for #{registration.event.name}"
  end

  def notify_overpayment(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: "Overpayment for #{registration.event.name}"
  end

end
