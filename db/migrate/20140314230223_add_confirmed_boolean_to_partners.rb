class AddConfirmedBooleanToPartners < ActiveRecord::Migration
  def change
    add_column :partners, :confirmed, :boolean
  end
end
