class RemoveGsmFromTicket < ActiveRecord::Migration
  def change
    remove_column :tickets, :gsm, :string
  end
end
