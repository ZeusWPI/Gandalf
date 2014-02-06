class RenameStudentNrColumnToStudentNumberRegistration < ActiveRecord::Migration
  def change
    rename_column :registrations, :student_nr, :student_number
  end
end
