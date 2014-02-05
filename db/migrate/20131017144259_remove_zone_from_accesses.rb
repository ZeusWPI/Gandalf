class RemoveZoneFromAccesses < ActiveRecord::Migration
  def change
    remove_reference :accesses, :zone, index: true
  end
end
