class CreateEvents < ActiveRecord::Migration[4.2]
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :start_date
      t.datetime :end_date
      t.string :location
      t.string :website
      t.text :description
      t.string :organisation

      t.timestamps
    end
  end
end
