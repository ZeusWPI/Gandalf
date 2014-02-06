class AddCommentToRegistration < ActiveRecord::Migration
  def change
    add_column :registrations, :comment, :text
  end
end
