class AddPublicToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :public, :boolean
  end
end
