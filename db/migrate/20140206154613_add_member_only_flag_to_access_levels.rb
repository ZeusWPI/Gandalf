class AddMemberOnlyFlagToAccessLevels < ActiveRecord::Migration
  def change
    add_column :access_levels, :member_only, :boolean
  end
end
