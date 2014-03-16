class AddEventIdToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :event_id, :integer
  end
end
