class ChangeRegistration < ActiveRecord::Migration
  def change
    change_table :registrations do |t|
      t.rename :paid, :paid_cents
    end
  end
end
