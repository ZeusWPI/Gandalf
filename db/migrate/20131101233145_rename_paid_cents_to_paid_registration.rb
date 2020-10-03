class RenamePaidCentsToPaidRegistration < ActiveRecord::Migration[4.2]
  def change
    rename_column :registrations, :paid_cents, :paid
  end
end
