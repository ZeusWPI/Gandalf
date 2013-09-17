class CreateZones < ActiveRecord::Migration
  def change
    create_table :zones do |t|
      t.string :name
      t.references :event, index: true

      t.timestamps
    end
    add_index :zones, [:name, :event_id], unique: true
  end
end
