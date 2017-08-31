class AddMoreTicketsInOneSale < ActiveRecord::Migration
  def change
    add_column :registrations, :number_of_tickets, :integer, :default => 1
    add_column :registrations, :sequence_number, :integer, :default => 1
  end
end
