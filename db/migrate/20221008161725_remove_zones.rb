class RemoveZones < ActiveRecord::Migration[6.1]
  def up
    drop_table :zones
  end
end
