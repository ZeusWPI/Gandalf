class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :invitee, index: true
      t.references :inviter, index: true
      t.text :comment
      t.integer :paid
      t.integer :price
      t.boolean :delivered, default: false
      t.boolean :accepted, default: false
      t.references :access_level, index: true

      t.timestamps
    end
  end
end
