class OrderMailer < ActionMailer::Base
  helper ApplicationHelper

  default from: 'noreply@event.fkgent.be'

  def confirm_order(order)
    @order = order
    mail to: "#{order.name} <#{order.email}>", subject: "Order for #{order.event.name}"
  end

  def notify_overpayment(order)
    @order = order
    mail to: "#{order.name} <#{order.email}>", subject: "Overpayment for #{order.event.name}"
  end
end
