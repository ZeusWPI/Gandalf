class ChangeColumnRegistration < ActiveRecord::Migration
  def change
    change_column :registrations, :barcode, :string
  end
end
