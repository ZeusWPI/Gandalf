class CreateClubsUserAssociation < ActiveRecord::Migration
  def change
    create_table :clubs_users do |t|
      t.belongs_to :club
      t.belongs_to :user
    end
  end
end
