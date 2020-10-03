class AddIndexToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_index :registrations, :payment_code, unique: true
  end
end
