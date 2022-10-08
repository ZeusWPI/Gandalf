class AddMoreDatabaseConsistency < ActiveRecord::Migration[6.1]
  def change
    ClubsUser.group(:user_id, :club_id).having("count(*) > 1").each do |cu|
      club_id = cu.club_id
      user_id = cu.user_id
      ClubsUser.delete_by(club_id: club_id, user_id: user_id)
      ClubsUser.create!(club_id: club_id, user_id: user_id)
    end
    add_index :clubs_users, [:club_id, :user_id], unique: true

    EnrolledClubsMember.group(:user_id, :club_id).having("count(*) > 1").each do |cu|
      club_id = cu.club_id
      user_id = cu.user_id
      EnrolledClubsMember.delete_by(club_id: club_id, user_id: user_id)
      EnrolledClubsMember.create!(club_id: club_id, user_id: user_id)
    end
    add_index :enrolled_clubs_members, [:club_id, :user_id], unique: true

    add_foreign_key :access_levels, :events, null: false, on_delete: :cascade

    add_foreign_key :events, :clubs, null: false, on_delete: :cascade

    add_foreign_key :partners, :events, null: false, on_delete: :cascade
    add_foreign_key :partners, :access_levels, null: false, on_delete: :restrict

    add_foreign_key :registrations, :events, null: false, on_delete: :cascade
    remove_foreign_key :registrations, :access_levels
    add_foreign_key :registrations, :access_levels, null: false, on_delete: :restrict

    drop_table :tickets
  end
end
