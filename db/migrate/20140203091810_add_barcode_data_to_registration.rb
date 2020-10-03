class AddBarcodeDataToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :barcode_data, :string
  end
end
