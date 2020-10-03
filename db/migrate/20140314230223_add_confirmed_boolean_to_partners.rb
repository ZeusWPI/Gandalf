class AddConfirmedBooleanToPartners < ActiveRecord::Migration[4.2]
  def up
    add_column :partners, :confirmed, :boolean
  end

  def down
    remove_column :partners, :confirmed
  end
end
