class RenameDeliveredToSelected < ActiveRecord::Migration
  def change
    change_table :invitations do |t|
      t.rename :delivered, :selected
    end
  end
end
