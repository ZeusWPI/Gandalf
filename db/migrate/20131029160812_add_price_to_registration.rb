class AddPriceToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :price, :integer
  end
end
