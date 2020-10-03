class AddFieldToPromos < ActiveRecord::Migration[4.2]
  def change
    add_column :promos, :sold_tickets, :integer, default: 0
  end
end
