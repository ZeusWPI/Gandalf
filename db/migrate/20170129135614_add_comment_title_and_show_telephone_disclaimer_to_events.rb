class AddCommentTitleAndShowTelephoneDisclaimerToEvents < ActiveRecord::Migration
  def change
    add_column :events, :comment_title, :string
    add_column :events, :show_telephone_disclaimer, :boolean, default: false
  end
end
