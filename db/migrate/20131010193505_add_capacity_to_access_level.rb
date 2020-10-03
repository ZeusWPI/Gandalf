class AddCapacityToAccessLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :capacity, :integer
  end
end
