class CreateIncludedZones < ActiveRecord::Migration[4.2]
  def change
    create_table :included_zones do |t|
      t.references :zone, index: true
      t.references :access_level, index: true

      t.timestamps
    end
  end
end
