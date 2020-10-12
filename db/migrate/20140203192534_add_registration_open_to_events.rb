class AddRegistrationOpenToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :registration_open, :boolean, default: true
  end
end
