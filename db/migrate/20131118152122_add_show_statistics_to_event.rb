class AddShowStatisticsToEvent < ActiveRecord::Migration[4.2]
  def change
    add_column :events, :show_statistics, :boolean
  end
end
