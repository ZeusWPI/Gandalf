class RemoveZoneAccessFromPeriod < ActiveRecord::Migration
  def change
    remove_reference :periods, :zone_access, index: true
  end
end
