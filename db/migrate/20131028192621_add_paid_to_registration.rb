class AddPaidToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :paid, :integer
  end
end
