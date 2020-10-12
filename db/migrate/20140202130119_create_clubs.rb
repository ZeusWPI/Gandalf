class CreateClubs < ActiveRecord::Migration[4.2]
  def change
    create_table :clubs do |t|
      t.string :full_name
      t.string :internal_name
      t.string :display_name

      t.timestamps
    end
  end
end
