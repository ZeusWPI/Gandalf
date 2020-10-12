class AddHiddenToAccessLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :hidden, :boolean
  end
end
