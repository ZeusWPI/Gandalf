class RemoveConfirmedFromPartner < ActiveRecord::Migration
  def change
    remove_column :partners, :confirmed, :boolean
  end
end
