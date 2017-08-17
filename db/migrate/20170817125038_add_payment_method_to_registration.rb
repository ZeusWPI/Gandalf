class AddPaymentMethodToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :payment_method, :string
    add_column :registrations, :payment_id, :string
  end
end
