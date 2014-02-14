class AddPaymentCodeToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :payment_code, :string
  end
end
