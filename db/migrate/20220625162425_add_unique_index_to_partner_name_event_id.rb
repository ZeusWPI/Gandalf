class AddUniqueIndexToPartnerNameEventId < ActiveRecord::Migration[6.1]
  def change
    add_index(:partners, [:name, :event_id], unique: true)
  end
end
