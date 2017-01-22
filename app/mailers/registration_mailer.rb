class RegistrationMailer < ActionMailer::Base

  helper ApplicationHelper

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: t('mailers.registration.subjects.confirm', event=registration.event.name)
  end

  def ticket(registration)
    @registration = registration

    barcode = Barcodes.create('EAN13', data: registration.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size

    image = Barcodes::Renderer::Image.new(barcode).render
    attachments.inline['barcode.png'] = image

    tilted_image = Magick::Image.from_blob(image).first.rotate!(-90).to_blob
    attachments.inline['barcode-tilted.png'] = tilted_image

    mail to: "#{registration.name} <#{registration.email}>", subject: t('mailers.registration.subjects.ticket', event=registration.event.name)
  end

  def notify_overpayment(registration)
    @registration = registration
    mail to: "#{registration.name} <#{registration.email}>", subject: t('mailers.registration.subjects.overpayment', event=registration.event.name)
  end

  def confirm_cancel(registration, event)
    @registration = registration
    @event = event

    mail to: "#{registration.name} <#{registration.email}>", subject: t('mailers.registration.subjects.cancel', event=registration.event.name)
  end
end
