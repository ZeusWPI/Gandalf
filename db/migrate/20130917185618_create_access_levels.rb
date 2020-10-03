class CreateAccessLevels < ActiveRecord::Migration[4.2]
  def change
    create_table :access_levels do |t|
      t.string :name
      t.references :event, index: true

      t.timestamps
    end
  end
end
