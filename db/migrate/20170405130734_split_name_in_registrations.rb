class SplitNameInRegistrations < ActiveRecord::Migration
  def change
    rename_column :registrations, :name, :lastname
    add_column :registrations, :firstname, :string
  end
end
