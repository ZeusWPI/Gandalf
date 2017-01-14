class AddPhoneNumberToRegistrations < ActiveRecord::Migration
  def change
    add_column :registrations, :phone_number, :string
  end
end
