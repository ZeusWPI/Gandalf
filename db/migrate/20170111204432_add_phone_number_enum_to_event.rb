class AddPhoneNumberEnumToEvent < ActiveRecord::Migration
  def change
    add_column :events, :phone_number_state, :integer, default: 0
  end
end
