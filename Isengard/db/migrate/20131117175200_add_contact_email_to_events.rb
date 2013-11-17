class AddContactEmailToEvents < ActiveRecord::Migration
  def change
    add_column :events, :contact_email, :string
  end
end
