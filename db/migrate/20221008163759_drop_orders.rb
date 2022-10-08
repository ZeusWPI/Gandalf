class DropOrders < ActiveRecord::Migration[6.1]
  def up
    drop_table :orders
  end
end
