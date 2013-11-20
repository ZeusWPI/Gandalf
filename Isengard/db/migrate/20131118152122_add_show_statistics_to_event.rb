class AddShowStatisticsToEvent < ActiveRecord::Migration
  def change
    add_column :events, :show_statistics, :boolean
  end
end
