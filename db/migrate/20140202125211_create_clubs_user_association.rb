class CreateClubsUserAssociation < ActiveRecord::Migration[4.2]
  def change
    create_table :clubs_users, id: false do |t|
      t.belongs_to :club
      t.belongs_to :user
    end
  end
end
