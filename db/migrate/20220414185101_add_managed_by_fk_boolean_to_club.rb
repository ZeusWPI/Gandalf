class AddManagedByFkBooleanToClub < ActiveRecord::Migration[6.0]
  def change
    add_column :clubs, :managed_by_fk, :boolean, default: true, null: false
  end
end
