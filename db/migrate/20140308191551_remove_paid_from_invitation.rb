class RemovePaidFromInvitation < ActiveRecord::Migration
  def change
    remove_column :invitations, :paid
  end
end
