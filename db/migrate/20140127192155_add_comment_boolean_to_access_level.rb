class AddCommentBooleanToAccessLevel < ActiveRecord::Migration[4.2]
  def change
    add_column :access_levels, :has_comment, :boolean
  end
end
