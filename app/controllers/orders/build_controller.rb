class Orders::BuildController < ApplicationController
  include Wicked::Wizard

  steps :add_tickets, :add_info, :add_ticket_info, :confirmation

  def show
    @event = Event.find params.require(:event_id)
    @order = @event.orders.find params.require(:order_id)

    case step
    when :add_tickets
      @access_levels = @event.access_levels.find_all { |al| can? :show, al }
      logger.debug @access_levels.partition(&:member_only?)
    when :add_info
    when :add_ticket_info
      @tickets = @order.tickets
    when :confirmation
    end

    render_wizard
  end

  def create
    @event = Event.find params.require(:event_id)
    @order = @event.orders.create! status: 'initial'

    redirect_to wizard_path(steps.first, order_id: @order.id)
  end

  def update
    @event = Event.find params.require(:event_id)
    @order = @event.orders.find params.require(:order_id)

    case step
    when :add_tickets
      @access_levels = @event.access_levels.find_all { |al| can? :show, al }
      params.require(:access_levels).each do |id, amount|
        amount = amount[:amount].to_i
        tickets = @order.tickets.where(access_level_id: id)
        if tickets.count > amount
          # destroy last tickets
          tickets.where.not(id: tickets.limit(amount).pluck(:id)).destroy_all
        else
          # create exactly as many as needed
          (amount - tickets.count).times do
            @order.tickets.create! access_level_id: id, status: 'initial'
          end
        end
      end
    when :add_info
      @order.update params.require(:order).permit(:name, :email, :email_confirmation, :gsm)
    when :add_ticket_info
      @tickets = @order.tickets
      params.require(:tickets).each do |id, ticket|
        @tickets.find(id).update_columns ticket.merge(status: 'filled_in')
      end
    when :confirmation
      @order.deliver
    end

    @order.status = step.to_s
    @order.status = 'active' if step == steps.last
    @order.save

    render_wizard @order
  end
end
