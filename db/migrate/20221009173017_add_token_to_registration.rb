class AddTokenToRegistration < ActiveRecord::Migration[6.1]
  def up
    # To be converted to UUID type when there's support for it in Rails+MySQL
    add_column :registrations, :token, :string, null: true
    Registration.find_each do |r|
      r.update_column(:token, SecureRandom.uuid)
    end
    change_column_null :registrations, :token, false

    add_index :registrations, :token
  end

  def down
    remove_index :registrations, :token
    remove_column :registrations, :token
  end
end
