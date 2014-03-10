class AddDefaultsToInvitation < ActiveRecord::Migration
  def up
    change_table :invitations do |t|
      t.change :accepted, :boolean, default: false
      t.change :sent, :boolean, default: false
    end
  end
end
