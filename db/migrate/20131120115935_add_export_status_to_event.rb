class AddExportStatusToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :export_status, :string
  end
end
