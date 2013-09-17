class CreateZoneAccesses < ActiveRecord::Migration
  def change
    create_table :zone_accesses do |t|
      t.references :zone, index: true
      t.references :period, index: true
      t.references :registration, index: true

      t.timestamps
    end
  end
end
