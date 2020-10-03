class AddEventIdToPartners < ActiveRecord::Migration[4.2]
  def change
    add_column :partners, :event_id, :integer
  end
end
