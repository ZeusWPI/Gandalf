class MakeEventUseClub < ActiveRecord::Migration
  def change
    remove_column :events, :organisation
    remove_column :events, :club
    add_column :events, :club_id, :integer
  end
end
