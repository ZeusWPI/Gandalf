class AddDefaultToAccessLevelPermit < ActiveRecord::Migration[6.1]
  def up
    change_column_default :access_levels, :permit, "everyone"
  end
end
