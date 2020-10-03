class AddDefaultValueToAccessLevels < ActiveRecord::Migration[4.2]
  def change
    change_column_default :access_levels, :public, true
  end
end
