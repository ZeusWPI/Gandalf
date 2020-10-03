class AddPriceToAccessLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :price, :integer
  end
end
