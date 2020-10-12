class RenameStudentNrColumnToStudentNumberRegistration < ActiveRecord::Migration[4.2]
  def change
    rename_column :registrations, :student_nr, :student_number
  end
end
