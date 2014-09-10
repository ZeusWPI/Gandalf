class OrderMailer < ActionMailer::Base

  helper ApplicationHelper

  default from: "noreply@event.fkgent.be"

  def confirm_order(order)
    @order = order
    mail to: "#{order.name} <#{order.email}>", subject: "Order for #{order.event.name}"
  end

  def ticket(order)
    @order = order

    barcode = Barcodes.create('EAN13', data: order.barcode_data, bar_width: 35, bar_height: 1500, caption_height: 300, caption_size: 275 ) # required: height > size
    attachments.inline['barcode.png'] = Barcodes::Renderer::Image.new(barcode).render

    mail to: "#{order.name} <#{order.email}>", subject: "Ticket for #{order.event.name}"
  end

  def notify_overpayment(order)
    @order = order
    mail to: "#{order.name} <#{order.email}>", subject: "Overpayment for #{order.event.name}"
  end

end
