class AddAccessLevelToAccesses < ActiveRecord::Migration
  def change
    add_reference :accesses, :access_level, index: true
  end
end
