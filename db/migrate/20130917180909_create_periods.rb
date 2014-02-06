class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.datetime :starts
      t.datetime :ends
      t.string :name

      t.timestamps
    end
  end
end
