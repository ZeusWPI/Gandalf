class AddEventIdToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_reference :registrations, :event, index: true
  end
end
