class ChangeRegistration < ActiveRecord::Migration[4.2]
  def change
    change_table :registrations do |t|
      t.rename :paid, :paid_cents
    end
  end
end
