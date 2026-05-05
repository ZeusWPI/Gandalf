class AddZeusUidToUser < ActiveRecord::Migration[6.1]
  def up
    add_column :users, :zeus_uid, :string
  end
end
