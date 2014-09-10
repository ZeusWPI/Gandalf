class OrdersController < ApplicationController
  include Wicked::Wizard

  steps :add_tickets, :add_info, :add_ticket_info, :pay
end
