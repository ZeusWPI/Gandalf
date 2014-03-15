class AddAccessLevelToPartner < ActiveRecord::Migration
  def change
    add_reference :partners, :access_level, index: true
  end
end
