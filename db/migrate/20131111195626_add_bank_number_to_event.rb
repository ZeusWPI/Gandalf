class AddBankNumberToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :bank_number, :string
  end
end
