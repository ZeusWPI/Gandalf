class AddEventToPeriod < ActiveRecord::Migration[4.2]
  def change
    add_reference :periods, :event, index: true
  end
end
