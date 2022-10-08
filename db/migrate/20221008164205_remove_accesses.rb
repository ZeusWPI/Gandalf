class RemoveAccesses < ActiveRecord::Migration[6.1]
  # Migrates all data from the accesses join table to a column on registration,
  # converting the many-to-many into a one-to-many
  def change
    # Cleanup registrations without tickets - they're corrupt anyway
    Registration.where.missing(:accesses).destroy_all

    # Add a new column, make it nullable
    add_reference :registrations, :access_level, type: :integer, foreign_key: true

    # Copy the information to the new column
    execute <<~SQL
      UPDATE registrations, accesses
      SET registrations.access_level_id  = accesses.access_level_id
      WHERE registrations.id = accesses.registration_id;
    SQL

    # Make the new column non-nullable
    change_column_null :registrations, :access_level_id, false

    # Remove the join table
    drop_table :accesses
  end
end
