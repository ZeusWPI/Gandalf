class AddCheckinColumnToRegistrations < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :checked_in_at, :datetime, default: nil
  end
end
