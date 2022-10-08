class RemoveIncludedZones < ActiveRecord::Migration[6.1]
  def up
    drop_table :included_zones
  end
end
