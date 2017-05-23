class AddClubToRegistrationAndRegisterClubsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :can_add_club, :boolean
    add_reference :registrations, :club
  end
end
