class RemoveDelayedJob < ActiveRecord::Migration[6.1]
  def up
    drop_table :delayed_jobs
  end
end
