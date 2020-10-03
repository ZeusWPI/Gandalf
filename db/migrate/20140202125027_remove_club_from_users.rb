class RemoveClubFromUsers < ActiveRecord::Migration[4.2]
  def change
    remove_column :users, :club
  end
end
