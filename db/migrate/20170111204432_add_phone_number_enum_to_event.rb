class AddPhoneNumberEnumToEvent < ActiveRecord::Migration
  def change
    add_column :events, :phone_number_state, :string, default: 'optional'
  end
end
