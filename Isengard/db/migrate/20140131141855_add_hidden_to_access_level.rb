class AddHiddenToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :hidden, :boolean
  end
end
