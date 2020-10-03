class PromoAccessLevelsJoinTable < ActiveRecord::Migration[4.2]
  def change
    create_join_table :promos, :access_levels
  end
end
