class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.references :partner, index: true
      t.references :access_level, index: true
      t.integer :price
      t.integer :paid
      t.integer :count

      t.timestamps
    end
  end
end
