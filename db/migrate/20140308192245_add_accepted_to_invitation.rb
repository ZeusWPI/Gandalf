class AddAcceptedToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :accepted, :boolean
  end
end
