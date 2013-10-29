class AddStudentNumberToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :student_nr, :string
  end
end
