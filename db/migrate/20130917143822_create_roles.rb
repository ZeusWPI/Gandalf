class CreateRoles < ActiveRecord::Migration[4.2]
  def change
    create_table :roles do |t|
      t.references :person, index: true
      t.references :event, index: true
      t.references :role_name, index: true

      t.timestamps
    end
    add_index :roles, [:person_id, :event_id, :role_name_id], unique: true
  end
end
