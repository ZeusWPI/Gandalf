class AddColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :show_ticket_count, :boolean, default: true
  end
end
