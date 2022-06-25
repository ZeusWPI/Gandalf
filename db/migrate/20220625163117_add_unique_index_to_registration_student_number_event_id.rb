class AddUniqueIndexToRegistrationStudentNumberEventId < ActiveRecord::Migration[6.1]
  def change
    add_index(:registrations, [:student_number, :event_id], unique: true)
  end
end
