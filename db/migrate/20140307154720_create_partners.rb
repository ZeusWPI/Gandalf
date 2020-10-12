class CreatePartners < ActiveRecord::Migration[4.2]
  def change
    create_table :partners do |t|
      t.string :name
      t.string :email
      t.string :authentication_token

      t.timestamps
    end
    add_index :partners, :authentication_token
  end
end
