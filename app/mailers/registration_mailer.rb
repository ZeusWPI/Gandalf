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

    # barcode = Barcodes.create('EAN13', data: registration.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size

    barcode = Barby::EAN13.new(registration.barcode_data)
    image = Barby::PngOutputter.new(barcode).to_png
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
