class AddSignatureToEvent < ActiveRecord::Migration
  def change
    add_column :events, :signature, :text
  end
end
