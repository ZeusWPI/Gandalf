class CreateRoleNames < ActiveRecord::Migration[4.2]
  def change
    create_table :role_names do |t|
      t.string :name

      t.timestamps
    end
    add_index :role_names, :name, unique: true
  end
end
