class AddBankNumberToEvent < ActiveRecord::Migration
  def change
    add_column :events, :bank_number, :string
  end
end
