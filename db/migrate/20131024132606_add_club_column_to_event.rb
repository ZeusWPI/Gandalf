class AddClubColumnToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :club, :string
    add_index :events, :club
  end
end
