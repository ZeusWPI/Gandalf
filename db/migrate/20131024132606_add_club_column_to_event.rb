class AddClubColumnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :club, :string
    add_index :events, :club
  end
end
