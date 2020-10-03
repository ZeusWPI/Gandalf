class RemoveRandomCheckFromRegistration < ActiveRecord::Migration[4.2]
  def change
    remove_column :registrations, :random_check, :integer
  end
end
