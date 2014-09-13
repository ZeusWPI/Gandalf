class RemoveEventFromTicket < ActiveRecord::Migration
  def change
    remove_reference :tickets, :event, index: true
  end
end
