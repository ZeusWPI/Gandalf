class AddCommentToRegistration < ActiveRecord::Migration[4.2]
  def change
    add_column :registrations, :comment, :text
  end
end
