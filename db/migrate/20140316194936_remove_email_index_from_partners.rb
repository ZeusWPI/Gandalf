class RemoveEmailIndexFromPartners < ActiveRecord::Migration[4.2]
  def change
    remove_index :partners, :email
  end
end
