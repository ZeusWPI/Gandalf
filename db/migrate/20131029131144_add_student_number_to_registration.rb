class AddStudentNumberToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :student_nr, :string
  end
end
