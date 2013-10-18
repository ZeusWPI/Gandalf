class AddPriceAndPubliclyAvaibleToAccessLevel < ActiveRecord::Migration
  def change
    add_column :access_levels, :price, :integer
    add_column :access_levels, :for_sale, :boolean
  end
end
