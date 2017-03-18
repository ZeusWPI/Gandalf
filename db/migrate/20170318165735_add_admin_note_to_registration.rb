class AddAdminNoteToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :admin_note, :string
  end
end
