class AddExportStatusToEvent < ActiveRecord::Migration
  def change
    add_column :events, :export_status, :string
  end
end
