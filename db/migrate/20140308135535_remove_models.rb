class RemoveModels < ActiveRecord::Migration[4.2]
  def change
    drop_table :roles
    drop_table :role_names
    drop_table :people
  end
end
