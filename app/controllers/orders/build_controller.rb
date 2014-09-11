class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  steps :add_tickets, :add_info, :add_ticket_info, :pay

  def show
    @event = Event.find params.require(:event_id)
    @order = @event.orders.find params.require(:order_id)

    case step
    when :add_tickets
      @access_levels = @event.access_levels.find_all { |al| can? :show, al }
    when :add_info
    when :add_ticket_info
    when :pay
    end

    render_wizard
  end

  def create
    @event = Event.find params.require(:event_id)
    @order = @event.orders.create status: steps.first.to_s

    redirect_to wizard_path(steps.first, order_id: @order.id)
  end

  def update
    @event = Event.find params.require(:event_id)
    @order = @event.orders.find params.require(:order_id)

    case step
    when :add_tickets
    when :add_info
      @order.update params.require(:order).permit(:name, :email, :email_confirmation, :gsm)
    when :add_ticket_info
    when :pay
    end

    @order.status = step.to_s
    @order.status = 'active' if step == steps.last
    @order.save

    render_wizard @order
  end

end
