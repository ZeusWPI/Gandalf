class AddAttachmentExportToEvent < ActiveRecord::Migration
  def self.up
    add_column :events, :export_file_name, :string
    add_column :events, :export_content_type, :string
    add_column :events, :export_file_size, :integer
    add_column :events, :export_updated_at, :datetime
  end

  def self.down
    remove_column :events, :export_file_name
    remove_column :events, :export_content_type
    remove_column :events, :export_file_size
    remove_column :events, :export_updated_at
  end
end
