class DeleteUnnecessaryTables < ActiveRecord::Migration
  def change
    drop_table :zones
    drop_table :accesses
    drop_table :periods
    drop_table :included_zones
  end
end
