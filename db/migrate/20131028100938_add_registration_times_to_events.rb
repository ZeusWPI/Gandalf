class AddRegistrationTimesToEvents < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :registration_open_date, :datetime
    add_column :events, :registration_close_date, :datetime
  end
end
