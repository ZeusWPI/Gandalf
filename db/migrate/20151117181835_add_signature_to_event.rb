class AddSignatureToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :signature, :text
  end
end
