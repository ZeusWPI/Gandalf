class CreatePromos < ActiveRecord::Migration
  def change
    create_table :promos do |t|
      t.references :event, index: true
      t.string :code
      t.integer :limit

      t.timestamps
    end
  end
end
