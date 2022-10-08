class AddMissingForeignKeys < ActiveRecord::Migration[6.1]
  def up
    add_foreign_key :clubs_users, :clubs, null: false, on_delete: :cascade
    add_foreign_key :clubs_users, :users, null: false, on_delete: :cascade

    add_foreign_key :enrolled_clubs_members, :clubs, null: false, on_delete: :cascade
    add_foreign_key :enrolled_clubs_members, :users, null: false, on_delete: :cascade
  end
end
