class RemoveEncryptedPasswordFromPartners < ActiveRecord::Migration[6.1]
  def up
    remove_column :partners, :encrypted_password
  end
end
