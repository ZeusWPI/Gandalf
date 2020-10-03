class RemoveZoneFromAccesses < ActiveRecord::Migration[4.2]
  def change
    remove_reference :accesses, :zone, index: true
  end
end
