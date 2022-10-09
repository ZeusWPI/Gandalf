class AddRequirePhysicalTicketToEvent < ActiveRecord::Migration[6.1]
  def up
    add_column :events, :require_physical_ticket, :boolean, null: false, default: false
  end
end
