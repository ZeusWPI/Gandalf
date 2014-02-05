class AddEventToPeriod < ActiveRecord::Migration
  def change
    add_reference :periods, :event, index: true
  end
end
