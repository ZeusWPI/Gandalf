class RemoveClubFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :club
  end
end
