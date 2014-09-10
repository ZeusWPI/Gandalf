class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.string :status
      t.string :name
      t.string :email
      t.string :gsm
      t.integer :ticket_id
      t.references :event, index: true
      t.integer :paid
      t.integer :price

      t.timestamps
    end
  end
end
