class RemoveEmailIndexFromPartners < ActiveRecord::Migration
  def change
    remove_index :partners, :email
  end
end
