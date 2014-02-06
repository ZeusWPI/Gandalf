class RenamePaidCentsToPaidRegistration < ActiveRecord::Migration
  def change
    rename_column :registrations, :paid_cents, :paid
  end
end
