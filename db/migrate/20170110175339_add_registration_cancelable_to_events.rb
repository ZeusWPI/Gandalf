class AddRegistrationCancelableToEvents < ActiveRecord::Migration
  def change
    add_column :events, :registration_cancelable, :boolean
  end
end
