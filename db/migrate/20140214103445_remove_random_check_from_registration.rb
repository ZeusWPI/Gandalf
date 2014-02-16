class RemoveRandomCheckFromRegistration < ActiveRecord::Migration
  def change
    remove_column :registrations, :random_check, :integer
  end
end
