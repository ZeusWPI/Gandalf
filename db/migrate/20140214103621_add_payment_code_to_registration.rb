class AddPaymentCodeToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :payment_code, :string

    Registration.reset_column_information

    Registration.find_each do |r|
      r.payment_code = Registration.create_payment_code
      r.save
    end
  end
end
