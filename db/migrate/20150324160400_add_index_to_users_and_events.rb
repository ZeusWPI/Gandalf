class AddIndexToUsersAndEvents < ActiveRecord::Migration
  def change
    add_index :registrations, [:name, :event_id], unique: true
  end
end
