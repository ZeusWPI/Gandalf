class AddAccessLevelToTicket < ActiveRecord::Migration
  def change
    add_reference :tickets, :access_level, index: true
  end
end
