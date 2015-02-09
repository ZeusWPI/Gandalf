class AddRandomCheckToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :random_check, :integer, limit: 8
  end
end
