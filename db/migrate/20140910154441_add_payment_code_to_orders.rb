class AddPaymentCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :payment_code, :string
  end
end
