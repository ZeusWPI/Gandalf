class RemoveAttachmentExportFromEvent < ActiveRecord::Migration[6.1]
  def down
    remove_column :events, :export_file_name
    remove_column :events, :export_content_type
    remove_column :events, :export_file_size
    remove_column :events, :export_updated_at
  end
end
