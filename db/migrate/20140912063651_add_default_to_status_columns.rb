class AddDefaultToStatusColumns < ActiveRecord::Migration
  def change
    change_column :tickets, :status, :string, default: 'initial'
    change_column :orders, :status, :string, default: 'initial'
  end
end
