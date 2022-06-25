class AddUniqueIndexToRegistrationNameEventId < ActiveRecord::Migration[6.1]
  def change
    add_index(:registrations, [:name, :event_id], unique: true)
  end
end
