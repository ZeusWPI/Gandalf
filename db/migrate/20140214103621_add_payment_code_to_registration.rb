class AddPaymentCodeToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :payment_code, :string

    Registration.reset_column_information

    Registration.find_each do |r|
      random = rand(10**15)
      r.payment_code = sprintf("GAN%02d%015d", random % 97, random)
      r.save
    end
  end
end
