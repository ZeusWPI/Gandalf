class RemoveAccessLevelFromPartner < ActiveRecord::Migration
  def change
    remove_reference :partners, :access_level, index: true
  end
end
