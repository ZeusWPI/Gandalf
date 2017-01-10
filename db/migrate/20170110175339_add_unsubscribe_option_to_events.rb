class AddUnsubscribeOptionToEvents < ActiveRecord::Migration
  def change
    add_column :events, :unsubscribe_option, :boolean
    add_column :events, :slug, :string
  end
end
