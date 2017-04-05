class AddPlusOneToRegistrations < ActiveRecord::Migration
  def change
    add_column :events, :allow_plus_one, :boolean
    add_column :registrations, :has_plus_one, :boolean
    add_column :registrations, :plus_one_title, :string
    add_column :registrations, :plus_one_firstname, :string
    add_column :registrations, :plus_one_lastname, :string
  end
end
