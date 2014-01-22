class AddCasfieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :cas_givenname, :string
    add_column :users, :cas_surname, :string
    add_column :users, :cas_ugentStudentID, :string
    add_column :users, :cas_mail, :string
    add_column :users, :cas_uid, :string
  end
end
