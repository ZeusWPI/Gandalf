class AddClubToRegistrationAndRegisterClubsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :can_add_club, :bool
    add_column :registrations, :club, :Club
  end
end
