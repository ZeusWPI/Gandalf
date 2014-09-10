class TicketMailer < ActionMailer::Base

  helper ApplicationHelper

  default from: "noreply@event.fkgent.be"

  def ticket(ticket)
    @ticket = ticket

    barcode = Barcodes.create('EAN13', data: ticket.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    attachments.inline['barcode.png'] = Barcodes::Renderer::Image.new(barcode).render

    mail to: "#{ticket.name} <#{ticket.email}>", subject: "Ticket for #{ticket.event.name}"
  end

end
