class RemovePeriods < ActiveRecord::Migration[6.1]
  def up
    remove_column :accesses, :period_id
    drop_table :periods
  end
end
