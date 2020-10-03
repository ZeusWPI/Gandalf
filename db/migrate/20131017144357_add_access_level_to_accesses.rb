class AddAccessLevelToAccesses < ActiveRecord::Migration[4.2]
  def change
    add_reference :accesses, :access_level, index: true
  end
end
