class AddFieldToPromos < ActiveRecord::Migration
  def change
    add_column :promos, :sold_tickets, :integer, default: 0
  end
end
