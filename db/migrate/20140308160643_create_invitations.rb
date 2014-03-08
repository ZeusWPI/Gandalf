class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.boolean :send
      t.references :access_level, index: true
      t.references :inviter, index: true
      t.references :invitee, index: true
      t.integer :price
      t.integer :paid

      t.timestamps
    end
  end
end
