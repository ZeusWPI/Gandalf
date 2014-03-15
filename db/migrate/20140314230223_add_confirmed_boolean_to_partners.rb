class AddConfirmedBooleanToPartners < ActiveRecord::Migration
  def up
    add_column :partners, :confirmed, :boolean
  end

  def down
    remove_column :partners, :confirmed
  end
end
