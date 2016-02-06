class DropAccessLevelPublic < ActiveRecord::Migration
  def up
    AccessLevel.where(public: false).each do |a|
      a.update_attribute :hidden, true
    end
    remove_column :access_levels, :public
  end

  def down
    add_column :access_levels, :public, :boolean, default: true
    AccessLevel.where(hidden: true).each do |a|
      a.update_attribute :public, false
    end
  end
end
