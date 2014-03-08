class AddPaidToInvitation < ActiveRecord::Migration
  def change
    add_column :invitations, :paid, :boolean
  end
end
