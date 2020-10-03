class AddPublicToAccessLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :public, :boolean
  end
end
