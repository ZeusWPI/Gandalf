class AddPaidToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :paid, :integer
  end
end
