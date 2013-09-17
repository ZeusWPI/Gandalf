class CreateAccessLevels < ActiveRecord::Migration
  def change
    create_table :access_levels do |t|
      t.string :name
      t.references :event, index: true

      t.timestamps
    end
  end
end
