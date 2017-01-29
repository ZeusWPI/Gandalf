class AddExtraInformationToEventsAndRegistration < ActiveRecord::Migration
  def change
    add_column :events, :extra_info, :boolean, default: false
    add_column :registrations, :title, :string
    add_column :registrations, :job_function, :string
  end
end
