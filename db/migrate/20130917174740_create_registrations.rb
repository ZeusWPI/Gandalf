class CreateRegistrations < ActiveRecord::Migration[4.2]
  def change
    create_table :registrations do |t|
      t.integer :barcode
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
