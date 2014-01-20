class AddCheckinColumnToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :checked_in_at, :integer, default: nil
  end
end
