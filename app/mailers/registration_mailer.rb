class RegistrationMailer < ActionMailer::Base

  helper ApplicationHelper

  def confirm_registration(registration)
    @registration = registration
    mail to: "#{registration.lastname} #{registration.firstname} <#{registration.email}>", subject: t('mailers.registration.subjects.confirm', :event => registration.event.name)
  end

  def ticket(registration)
    @registration = registration

    if @registration.number_of_tickets == 1
      subject = t('mailers.registration.subjects.ticket', :event => registration.event.name)
    else
      subject = t('mailers.registration.subjects.multiple_ticket', :event => registration.event.name, :number_of_tickets => @registration.number_of_tickets, :sequence_number => @registration.sequence_number)
    end

    barcode = Barcodes.create('EAN13', data: registration.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size

    image = Barcodes::Renderer::Image.new(barcode).render
    #TODO: remove me and add if attachments.inline['barcode.png'] = image

    tilted_image = Magick::Image.from_blob(image).first.rotate!(-90).to_blob
    attachments.inline['barcode-tilted.png'] = tilted_image

    mail to: "#{registration.lastname} #{registration.firstname} <#{registration.email}>", subject: subject
  end

  def notify_overpayment(registration)
    @registration = registration
    mail to: "#{registration.lastname} #{registration.firstname} <#{registration.email}>", subject: t('mailers.registration.subjects.overpayment', :event => registration.event.name)
  end

  def confirm_cancel(registration, event)
    @registration = registration
    @event = event

    mail to: "#{registration.lastname} #{registration.firstname} <#{registration.email}>", subject: t('mailers.registration.subjects.cancel', :event => registration.event.name)
  end

  def payment_failed(registration, event)
    @registration = registration
    @event = event

    if @registration.number_of_tickets == 1
      subject = t('mailers.registration.subjects.failed', :event => registration.event.name)
    else
      subject = t('mailers.registration.subjects.multiple_failed', :event => registration.event.name, :number_of_tickets => @registration.number_of_tickets)
    end

    mail to: "#{registration.lastname} #{registration.firstname} <#{registration.email}>", subject: subject
  end
end
