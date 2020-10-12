class AddAccessLevelToPartner < ActiveRecord::Migration[4.2]
  def up
    add_reference :partners, :access_level, index: true
  end

  def down
    remove_column :partners, :access_level
  end
end
