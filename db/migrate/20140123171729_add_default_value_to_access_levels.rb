class AddDefaultValueToAccessLevels < ActiveRecord::Migration
  def change
    change_column_default :access_levels, :public, true
  end
end
