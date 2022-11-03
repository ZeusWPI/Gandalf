class DropPromos < ActiveRecord::Migration[6.1]
  def up
    drop_table :promos
    drop_table :access_levels_promos
  end
end
