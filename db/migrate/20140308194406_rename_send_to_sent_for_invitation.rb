class RenameSendToSentForInvitation < ActiveRecord::Migration
  def change
    rename_column :invitations, :send, :sent
  end
end
