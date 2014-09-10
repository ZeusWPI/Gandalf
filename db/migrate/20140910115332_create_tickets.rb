class CreateTickets < ActiveRecord::Migration
  def change
    create_table :tickets do |t|
      t.string :name
      t.string :email
      t.string :gsm
      t.datetime :checked_in_at
      t.references :event, index: true
      t.references :order, index: true
      t.string :student_number
      t.text :comment
      t.string :barcode
      t.string :barcode_data

      t.timestamps
    end
  end
end
