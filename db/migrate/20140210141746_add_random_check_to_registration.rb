class AddRandomCheckToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :random_check, :integer, limit: 8

    Registration.reset_column_information

    Registration.find_each do |r|
      r.random_check = rand(10 ** 15)
      r.save
    end
  end
end
