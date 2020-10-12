class AddMemberOnlyFlagToAccessLevels < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :member_only, :boolean
  end
end
