class AddUniqueIndexToClubInternalName < ActiveRecord::Migration[6.1]
  def change
    add_index(:clubs, :internal_name, unique: true)
  end
end
