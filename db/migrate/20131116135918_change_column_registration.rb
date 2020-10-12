class ChangeColumnRegistration < ActiveRecord::Migration[4.2]
  def change
    change_column :registrations, :barcode, :string
  end
end
