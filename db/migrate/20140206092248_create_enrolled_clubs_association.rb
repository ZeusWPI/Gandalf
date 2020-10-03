class CreateEnrolledClubsAssociation < ActiveRecord::Migration[4.2]
  def change
    create_join_table :clubs, :users, table_name: :enrolled_clubs_members do |t|
      t.index :club_id
      t.index :user_id
    end
  end
end
