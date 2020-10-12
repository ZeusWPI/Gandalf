class AddColumnToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :show_ticket_count, :boolean, default: true
  end
end
