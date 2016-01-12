class AccessLevelPermitEnum < ActiveRecord::Migration
  def up
    add_column :access_levels, :permit, :string, :default => :everyone
    AccessLevel.all.each do |a|
      a.update_attribute :permit, :members if a.member_only
    end
    remove_column :access_levels, :member_only
  end

  def down
    add_column :access_levels, :member_only, :boolean
    AccessLevel.all.each do |a|
      a.update_attribute :member_only, a.permit_members?
    end
    remove_column :access_levels, :permit
  end
end
