class RemoveModels < ActiveRecord::Migration
  def change
    drop_table :roles
    drop_table :role_names
    drop_table :people
  end
end
