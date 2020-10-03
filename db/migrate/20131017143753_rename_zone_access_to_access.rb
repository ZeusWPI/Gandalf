class RenameZoneAccessToAccess < ActiveRecord::Migration[4.2]
  def change
    rename_table :zone_accesses, :accesses
  end
end
